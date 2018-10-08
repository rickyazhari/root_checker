package com.neki.rootchecker;


import android.os.Build;
import android.util.Log;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** RootCheckerPlugin */
public class RootCheckerPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "root_checker");
    channel.setMethodCallHandler(new RootCheckerPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("isDeviceRooted")) {
      checkRootDevice(result);
    } else {
      result.notImplemented();
    }
  }

  private void checkRootDevice(Result result){
    result.success(isCanExecuteCommand() && isPathExist() && isTestBuild());
  }

  private boolean isPathExist(){
    String[] paths ={
      "/system/app/Superuser.apk",
      "/sbin/su",
      "/system/bin/su",
      "/system/xbin/su",
      "/data/local/xbin/su",
      "/data/local/bin/su",
      "/system/sd/xbin/su",
      "/system/bin/failsafe/su",
      "/data/local/su",
      "/su/bin/su",
    };
    for(String path : paths){
      if(new File(path).exists()){
        Log.e("ROOT_CHECKER","Path is exist : "+path);
        return true;
      }
    }
    return false;
  }

  private boolean isCanExecuteCommand(){
    Process process = null;
    try{
      process = Runtime.getRuntime().exec(new String[]{"/system/xbin/which","su"});
      BufferedReader in = new BufferedReader(new InputStreamReader(process.getInputStream()));
      if(in.readLine() != null){
        Log.e("ROOT_CHECKER","cammand executed");
        return true;
      }
      return false;
    }catch (Exception e){
      return false;
    }finally {
      if(process != null){
        process.destroy();
      }
    }
  }

  private boolean isTestBuild(){
    String buildTags = Build.TAGS;
    if(buildTags != null && buildTags.contains("test-keys")){
      Log.e("ROOT_CHECKER","devices buid with test key");
      return true;
    }
    return false;
  }

}
