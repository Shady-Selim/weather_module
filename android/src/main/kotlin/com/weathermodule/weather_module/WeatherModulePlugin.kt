package com.weathermodule.weather_module

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL
import java.util.concurrent.TimeUnit

/** WeatherModulePlugin - Handles weather API calls */
class WeatherModulePlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "weather_module")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getTodayTemperature" -> {
        val cityName = call.argument<String>("cityName")
        if (cityName.isNullOrBlank()) {
          result.error("INVALID_ARGUMENT", "City name cannot be empty", null)
          return
        }
        
        // Handle API call on background thread
        CoroutineScope(Dispatchers.IO).launch {
          try {
            val temperature = fetchTemperature(cityName)
            withContext(Dispatchers.Main) {
              result.success(temperature)
            }
          } catch (e: WeatherException) {
            withContext(Dispatchers.Main) {
              result.error("WEATHER_ERROR", e.message, null)
            }
          } catch (e: Exception) {
            withContext(Dispatchers.Main) {
              result.error("UNKNOWN_ERROR", "Unexpected error: ${e.message}", null)
            }
          }
        }
      }
      else -> result.notImplemented()
    }
  }

  private suspend fun fetchTemperature(cityName: String): Double = withContext(Dispatchers.IO) {
    val baseUrl = "https://wttr.in"
    val encodedCityName = java.net.URLEncoder.encode(cityName.trim(), "UTF-8")
      .replace("+", "%20")
    val urlString = "$baseUrl/$encodedCityName?format=j1"
    
    val url = URL(urlString)
    val connection = url.openConnection() as HttpURLConnection
    
    try {
      connection.connectTimeout = 10000
      connection.readTimeout = 10000
      connection.requestMethod = "GET"
      connection.connect()
      
      when (connection.responseCode) {
        200 -> {
          val responseBody = connection.inputStream.bufferedReader().use { it.readText() }
          val json = JSONObject(responseBody)
          
          val currentCondition = json.getJSONArray("current_condition")
          if (currentCondition.length() == 0) {
            throw WeatherException("Invalid API response: current_condition not found")
          }
          
          val condition = currentCondition.getJSONObject(0)
          if (!condition.has("temp_C")) {
            throw WeatherException("Invalid API response: temperature not found")
          }
          
          val tempC = condition.getString("temp_C")
          val temperature = tempC.toDoubleOrNull()
          
          if (temperature == null) {
            throw WeatherException("Invalid API response: temperature format is invalid")
          }
          
          temperature
        }
        404 -> throw WeatherException("City not found: \"$cityName\"")
        else -> throw WeatherException("API error: Received status code ${connection.responseCode}")
      }
    } catch (e: WeatherException) {
      throw e
    } catch (e: java.net.SocketTimeoutException) {
      throw WeatherException("Request timeout: Could not fetch weather data within 10 seconds")
    } catch (e: java.net.UnknownHostException) {
      throw WeatherException("Network error: ${e.message}")
    } catch (e: Exception) {
      throw WeatherException("Unexpected error: ${e.message}")
    } finally {
      connection.disconnect()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

private class WeatherException(message: String) : Exception(message)

