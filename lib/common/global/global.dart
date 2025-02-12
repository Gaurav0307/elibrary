import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
late String token;
late String userId;

final documents = [
  {
    'name': 'Android Programming Cookbook',
    'link':
        'https://enos.itcollege.ee/~jpoial/allalaadimised/reading/Android-Programming-Cookbook.pdf'
  },
];

final images = [
  {
    'name': 'Arches National Park',
    'link':
        'https://upload.wikimedia.org/wikipedia/commons/6/60/The_Organ_at_Arches_National_Park_Utah_Corrected.jpg'
  },
  {
    'name': 'Canyonlands National Park',
    'link':
        'https://upload.wikimedia.org/wikipedia/commons/7/78/Canyonlands_National_Park%E2%80%A6Needles_area_%286294480744%29.jpg'
  },
  {
    'name': 'Death Valley National Park',
    'link':
        'https://upload.wikimedia.org/wikipedia/commons/b/b2/Sand_Dunes_in_Death_Valley_National_Park.jpg'
  },
  {
    'name': 'Gates of the Arctic National Park and Preserve',
    'link':
        'https://upload.wikimedia.org/wikipedia/commons/e/e4/GatesofArctic.jpg'
  }
];

final videos = [
  {
    'name': 'Big Buck Bunny',
    'link':
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'
  },
  {
    'name': 'Elephant Dream',
    'link':
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'
  }
];

const String apiBaseUrl = "https://rest-apis-chat-app.onrender.com";
// const String apiBaseUrl =
//     "https://4351-2401-4900-8837-2bd3-2df5-57d8-4351-7750.ngrok-free.app";
