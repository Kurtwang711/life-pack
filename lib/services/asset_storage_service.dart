import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/asset_file.dart';

class AssetStorageService {
  static const String _storageKey = 'life_pack_assets';
  
  // 保存资产列表到本地存储
  static Future<bool> saveAssets(List<AssetFile> assets) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 将资产列表转换为 JSON
      final List<Map<String, dynamic>> jsonList = assets.map((asset) {
        return {
          'id': asset.id,
          'assetType': asset.assetType,
          'primaryInfo': asset.primaryInfo,
          'note': asset.note,
          'timestamp': asset.timestamp.toIso8601String(),
          'details': asset.details,
          'colors': asset.colors.map((color) => color.value).toList(),
        };
      }).toList();
      
      // 保存到 SharedPreferences
      final String jsonString = jsonEncode(jsonList);
      return await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      print('保存资产数据失败: $e');
      return false;
    }
  }
  
  // 从本地存储加载资产列表
  static Future<List<AssetFile>> loadAssets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_storageKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      
      // 解析 JSON
      final List<dynamic> jsonList = jsonDecode(jsonString);
      
      // 转换为 AssetFile 对象列表
      return jsonList.map((json) {
        return AssetFile(
          id: json['id'],
          assetType: json['assetType'],
          primaryInfo: json['primaryInfo'],
          note: json['note'] ?? '',
          timestamp: DateTime.parse(json['timestamp']),
          details: Map<String, String>.from(json['details']),
          colors: (json['colors'] as List<dynamic>)
              .map((colorValue) => Color(colorValue))
              .toList(),
        );
      }).toList();
    } catch (e) {
      print('加载资产数据失败: $e');
      return [];
    }
  }
  
  // 添加单个资产
  static Future<bool> addAsset(AssetFile asset) async {
    try {
      final assets = await loadAssets();
      assets.add(asset);
      return await saveAssets(assets);
    } catch (e) {
      print('添加资产失败: $e');
      return false;
    }
  }
  
  // 更新资产
  static Future<bool> updateAsset(AssetFile updatedAsset) async {
    try {
      final assets = await loadAssets();
      final index = assets.indexWhere((asset) => asset.id == updatedAsset.id);
      
      if (index != -1) {
        assets[index] = updatedAsset;
        return await saveAssets(assets);
      }
      
      return false;
    } catch (e) {
      print('更新资产失败: $e');
      return false;
    }
  }
  
  // 删除资产
  static Future<bool> deleteAsset(String assetId) async {
    try {
      final assets = await loadAssets();
      assets.removeWhere((asset) => asset.id == assetId);
      return await saveAssets(assets);
    } catch (e) {
      print('删除资产失败: $e');
      return false;
    }
  }
  
  // 清空所有资产
  static Future<bool> clearAllAssets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_storageKey);
    } catch (e) {
      print('清空资产数据失败: $e');
      return false;
    }
  }
}