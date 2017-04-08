---
layout: post
title:  "안드로이드 블루투스의 비동기 처리와 Concurrent Util"
date:   2017-04-8 16:38:34 +0900
post_author : Ted
categories: jekyll update
---
안드로이드 블루투스의 비동기 처리와 Concurrent Util

안드로이드 블루투스 통신은 직토워크의 초기부터 개발팀이 공을 많이 들인 부분이다. 아마 대부분의 Bluetooth Low Energy(이하 BLE)를 사용하는 디바이스의 애플리케이션을 제작하는 회사는 마찬 가지라고 믿고 있다. 일반적으로 GATT Profile을 이용하여 Characteristic을 만들어서 읽거나, 마치 UART 통신처럼 프로토콜을 제작하여서 데이터 통신을 하는 경우가 대부분이다.

이번 글에서는 BLE의 하드웨어 통신보다 Android Framework에서 효율적으로 통신보다 Bluetooth 어댑터관리와 효율적인 이벤트를 처리하는 방법에 대해서 이야기하려고 한다.

대부분의 BLE의 통신에 대한 이벤트는 대부분 Callback함수를 Override하여서 사용하게 되어있다. 다른 명령을 Write하더라도 항상 같은 부분에서 이벤트가 발생하기 때문에 여러 이벤트에 대한 순차적 처리를 하기 어려운 부분이 있다. 직토워크의 경우는 A라는 Characteristic에 데이터를 쓰면 B라는 Characteristic에서 Notify가 오는 구조로 설계되어 있다. 또한 대부분의 통신이 순차적으로 처리되야 한다.

Daisy Chain형태의 구조를 개선하고 각 모듈(통신 프로토콜)의 재사용을 위해서 처음 도입했던 것이 Java의 Concurrent Util이다. 생각보다 편하게 쓸 수 있는 클래스를 많이 제공해 주고 있다. 

초기화 문제
BLE가 초기화가 되려면 
1.	BluetoothManager의 획득
bluetoothManager = (android.bluetooth.BluetoothManager) MainApplication.getApplication().getSystemService(Context.BLUETOOTH_SERVICE);

2.	BluetoothAdapater의 획득
bluetoothAdapter = bluetoothManager.getAdaperter();
3.	Device의 획득
device = bluetoothAdapter.getRemoteDevice(MACAddress);
위 세부분은 시스템에서 받아오는 부분이기 때문에 함수들이 Synchronous하게 호출 되지만, 이후 부터는 실제 Bluetooth를 통해서 디바이스(직토워크)와 통신하는 부분이기 때문에 대부분 asynchronous하게 실행된다.

BLE에 Write이 가능한 상태가 되려면
1.	디바이스를 스캔
2.	connectGatt
3.	원하는 몇 개의 Service를 Discover
4.	원하는 몇 개의 Characteristic을 Discover
5.	서비스의 Descriptor를 notify로 변경

총 4개의 이벤트가 발생한 후에 Write를 시작할 수 있다. Semaphore를 이용하면 쉽게 구현이 가능하지만 계속 별도의 Semaphore를 생성 해주어야하는 문제와 Semaphore를 wait하는 과정에서 BLE가 동작이 원할하지 않는 현상을 발생하였다.(BLE는 Framework에서 처리하여서 오는 이벤트이기 때문에 비동기 혹은 background 모듈 사용시 항상 시행착오가 많았다.) Concurrent Util에서 CountdownLatch를 이용하여 간단하게 해결하였고, BLE 동작성 역시 문제가 없었다.
initializeLatch = CountDownLatch(4);
이벤트를 체크하고 싶은 곳에 initializeLatch.countDown();
을 추가하여 15초이내에 4개의 이벤트가 모두 발생하면 초기화가 완료되고 그렇지 않으면 초기화가 실패하는 루틴을 생성하였다.

initializeLatch.await(15, TimeUnit.SECONDS);


그 결과, 원할하게 초기화 프로세스가 진행되었고, 4스텝중에 한 곳에서라도 문제가 생기면 15초후에는 에러 처리를 한 곳에서 할 수 있게 되었다.

여러 프로토콜의 실행

그 다음 해결해야 하는 문제는 이러한 쓰고/읽는 프로토콜을 serial하게 실행시킬 수 있는 manager가 필요하였다.

이곳에서는 ExecutorService와 Future를 AsyncTask에서 처리하여서 UI에서 부드럽게 처리할 수 있게 하였다.

ExecutorService pool = Executors.newSingleThreadExecutor();
Future<Integer> pedoFuture = pool.submit(new GetPedoRunnable(bluetoothLeModuleHandler, address));
Future<ArrayList<Integer>> walkingScoreFuture = pool.submit(new GetSoundWalkingScoreRunnable(bluetoothLeModuleHandler, address));
Future<Integer> batteryFuture = pool.submit(new GetBatteryDataCallable(bluetoothLeModuleHandler, address));
Future<WalkNumber> walkNumberFuture = pool.submit(new GetWalkNumberCallable(bluetoothLeModuleHandler, address));
Future<LinkedList<Byte>> activityDataFuture = pool.submit(new GetActivityDataRunnable(bluetoothLeModuleHandler, address));

// link and reset
Future<String> linkFuture = pool.submit(new GetDeviceLinkCallable(bluetoothLeModuleHandler, address));
Future<Integer> resetFuture = pool.submit(new SyncResetRunnable(bluetoothLeModuleHandler, address));

// disconnect
pool.submit(new DisconnectCallable(bluetoothLeModuleHandler, address));
pool.shutdown();


SyncWalkPhaseOneAsyncTask syncWalkPhaseOneAsyncTask = new SyncWalkPhaseOneAsyncTask(pedoFuture, walkingScoreFuture, batteryFuture, walkNumberFuture, walkingPostureFuture); // otaFuture
  syncWalkPhaseOneAsyncTask.execute();
SyncWalkPhaseTwoAsyncTask syncWalkPhaseTwoAsyncTask = new SyncWalkPhaseTwoAsyncTask(walkingScoreFuture, activityDataFuture, linkFuture, resetFuture);

syncWalkPhaseTwoAsyncTask.execute();

ExecutorService의 SingleThreadExecutor를 이용하여 추가되는 Runnable을 순차적으로 실행할 수 있게 하였고, 각 runnbable에서 얻게되는 결과값을 AsyncTask에서 Future통해 받은 후 UI에서 업데이트 할 수 있게 하였다.

항상 async의 문제는 handler나 asynctask등을 통하여서 thread에 접근하여서 UI를 그리는 권한이 있는 thread에 데이터를 전달해주는 부분이 문제였다. Handler를 쓰면 간단하게 해결되는 경우가 많지만 메시지가 남발되어 제대로 관리하지 않으면 재사용이 불가능한 코드가 되버리기 쉽상이다.

Web 통신과 같이 bluetooth통신 역시 Program자체보다 Environment에 의해서 이벤트가 발생하고 그것에 대한 concurrency control을 얼마나 효율적으로 하느냐가 관건이다. 조금 우겨 넣는 것 같지만, 이러한 “Reactive”한 이벤트처리에는 ReactiveX를 이용해보는 것을 어떨까.


감사합니다.

[zikto-page]: https://www.zikto.com
