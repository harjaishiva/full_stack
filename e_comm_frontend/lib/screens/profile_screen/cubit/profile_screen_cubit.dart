import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/screens/api_urls/urls.dart';
import 'package:e_commerce_app/utils/constants/methods.dart';
import 'package:e_commerce_app/utils/constants/variables.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

part 'profile_screen_state.dart';

class ProfileScreenCubit extends Cubit<ProfileScreenState> {
  ProfileScreenCubit() : super(ProfileScreenInitial());

  uploadImage(File images) async {
   try{
    String urlStr = baseUrl+uploadimage;
    Uri url = Uri.parse(urlStr);

   var request = http.MultipartRequest('POST',url);
   var id = SharedPreferencesClass.pref.getString(userId
   );

   request.fields['id'] = id ?? "";

   var stream = http.ByteStream(images.openRead());
   var length = await images.length();

   var mutipartFile = http.MultipartFile(
    'image',stream,length,filename: basename(images.path)
   );

   request.files.add(mutipartFile);

   var response = await request.send();

   if(response.statusCode == 200){
    var respstr = await response.stream.bytesToString();
    var jsonres = jsonDecode(respstr);
    log("response == $jsonres");
    SharedPreferencesClass.pref.setString(image,jsonres['path']);
   }
   else{
    log("error");
   }

   }catch(e){log("error while image upload =  == $e");}

  }
}
