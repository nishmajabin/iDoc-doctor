import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/handlers/call/call_engine.dart';
import 'package:idoc_doctor_side/core/handlers/call/call_engine_handler.dart';
import 'package:idoc_doctor_side/core/handlers/call/call_signalling_handler.dart';

class CallRepository {
  CallRepository({FirebaseFirestore? firestore})
      : _signaling = CallSignalingHandler(firestore: firestore),
        _engine = CallEngine();

  final CallSignalingHandler _signaling;
  final CallEngine _engine;

  bool get isReady => _engine.isReady;

  // ── Firestore signaling ──────────────────────────────────────────────────

  Future<void> createCallDocument({
    required String appointmentId,
    required String doctorId,
    required String userId,
    required String doctorName,
    required String patientName,
    String? doctorProfileImageUrl,
  }) =>
      _signaling.createCallDocument(
        appointmentId: appointmentId,
        doctorId: doctorId,
        userId: userId,
        doctorName: doctorName,
        patientName: patientName,
        doctorProfileImageUrl: doctorProfileImageUrl,
      );

  Stream<String?> watchCallStatus({required String callId}) =>
      _signaling.watchCallStatus(callId: callId);

  Future<void> endCallDocument({required String callId}) =>
      _signaling.endCallDocument(callId: callId);

  // ── Agora engine ──────────────────────────────────────────────────────────

  Future<void> initAndJoin({
    required String appId,
    required String channelName,
    required String userId,
    required OnRemoteUserJoined onRemoteUserJoined,
    required OnRemoteUserLeft onRemoteUserLeft,
    required OnError onError,
  }) =>
      _engine.initAndJoin(
        appId: appId,
        channelName: channelName,
        userId: userId,
        onRemoteUserJoined: onRemoteUserJoined,
        onRemoteUserLeft: onRemoteUserLeft,
        onError: onError,
      );

  Future<void> leaveAndDispose() => _engine.leaveAndDispose();

  // ── Controls ──────────────────────────────────────────────────────────────

  Future<void> muteLocalAudio({required bool mute}) =>
      _engine.muteLocalAudio(mute: mute);

  Future<void> switchCamera() => _engine.switchCamera();

  // ── Video views ───────────────────────────────────────────────────────────

  Widget buildLocalView() => _engine.buildLocalView();

  Widget buildRemoteView({required String channelName, required int remoteUid}) =>
      _engine.buildRemoteView(channelName: channelName, remoteUid: remoteUid);
}