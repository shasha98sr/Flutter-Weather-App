import 'package:http/http.dart' as http;
import 'package:weatherapp/model/weather_model.dart';

class WeatherApi {
  static const String _endpointOpenWeather= "https://api.openweathermap.org/data/2.5/weather";
  static const String _apiKey = "e8ef5fc443ad455abd669649118e4180";



  static Future<WeatherModel> getWeather(String location) async {
    var url = Uri.parse(
        _endpointOpenWeather +"?q="+location+"&appid="+_apiKey+"&units=metric");
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      return weatherModelFromJson(response.body);
    }else{
      throw Exception('Failed to load weather');
    }
    

  }
}
