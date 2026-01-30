import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:idoc_doctor_side/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/data/repositories/doctor_repository.dart';
import 'doctor_application_event.dart';
import 'doctor_application_state.dart';

class DoctorApplicationBloc extends Bloc<DoctorApplicationEvent, DoctorApplicationState> {
  final DoctorRepository _repository = DoctorRepository();
  
  String? _gender;
  String? _specialist;
  File? _licenseFile;
  String? _licenseFileName;
  File? _profileImage;
  String? _profileImageName;

  DoctorApplicationBloc() : super(DoctorApplicationInitial()) {
    on<UpdateGenderEvent>(_onUpdateGender);
    on<UpdateSpecialistEvent>(_onUpdateSpecialist);
    on<PickLicenseFileEvent>(_onPickLicenseFile);
    on<PickProfileImageEvent>(_onPickProfileImage);
    on<SubmitApplicationEvent>(_onSubmitApplication);
    on<ResetApplicationEvent>(_onResetApplication);
  }

  void _onUpdateGender(UpdateGenderEvent event, Emitter<DoctorApplicationState> emit) {
    _gender = event.gender;
    emit(DoctorApplicationFormUpdated(
      gender: _gender,
      specialist: _specialist,
      licenseFile: _licenseFile,
      licenseFileName: _licenseFileName,
      profileImage: _profileImage,
      profileImageName: _profileImageName,
    ));
  }

  void _onUpdateSpecialist(UpdateSpecialistEvent event, Emitter<DoctorApplicationState> emit) {
    _specialist = event.specialist;
    emit(DoctorApplicationFormUpdated(
      gender: _gender,
      specialist: _specialist,
      licenseFile: _licenseFile,
      licenseFileName: _licenseFileName,
      profileImage: _profileImage,
      profileImageName: _profileImageName,
    ));
  }

  Future<void> _onPickLicenseFile(PickLicenseFileEvent event, Emitter<DoctorApplicationState> emit) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        _licenseFile = File(result.files.single.path!);
        _licenseFileName = result.files.single.name;
        
        emit(DoctorApplicationFormUpdated(
          gender: _gender,
          specialist: _specialist,
          licenseFile: _licenseFile,
          licenseFileName: _licenseFileName,
          profileImage: _profileImage,
          profileImageName: _profileImageName,
        ));
      }
    } catch (e) {
      emit(DoctorApplicationFailure(
        'Failed to pick file: ${e.toString()}',
        gender: _gender,
        specialist: _specialist,
        licenseFile: _licenseFile,
        licenseFileName: _licenseFileName,
        profileImage: _profileImage,
        profileImageName: _profileImageName,
      ));
      // Emit form updated state after error to restore UI
      emit(DoctorApplicationFormUpdated(
        gender: _gender,
        specialist: _specialist,
        licenseFile: _licenseFile,
        licenseFileName: _licenseFileName,
        profileImage: _profileImage,
        profileImageName: _profileImageName,
      ));
    }
  }

  Future<void> _onPickProfileImage(PickProfileImageEvent event, Emitter<DoctorApplicationState> emit) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.single.path != null) {
        _profileImage = File(result.files.single.path!);
        _profileImageName = result.files.single.name;
        
        emit(DoctorApplicationFormUpdated(
          gender: _gender,
          specialist: _specialist,
          licenseFile: _licenseFile,
          licenseFileName: _licenseFileName,
          profileImage: _profileImage,
          profileImageName: _profileImageName,
        ));
      }
    } catch (e) {
      emit(DoctorApplicationFailure(
        'Failed to pick image: ${e.toString()}',
        gender: _gender,
        specialist: _specialist,
        licenseFile: _licenseFile,
        licenseFileName: _licenseFileName,
        profileImage: _profileImage,
        profileImageName: _profileImageName,
      ));
      // Emit form updated state after error to restore UI
      emit(DoctorApplicationFormUpdated(
        gender: _gender,
        specialist: _specialist,
        licenseFile: _licenseFile,
        licenseFileName: _licenseFileName,
        profileImage: _profileImage,
        profileImageName: _profileImageName,
      ));
    }
  }

  Future<void> _onSubmitApplication(SubmitApplicationEvent event, Emitter<DoctorApplicationState> emit) async {
    emit(DoctorApplicationLoading());
    
    try {
      // Validate passwords match
      if (event.password != event.confirmPassword) {
        emit(DoctorApplicationFailure(
          'Passwords do not match',
          gender: _gender,
          specialist: _specialist,
          licenseFile: _licenseFile,
          licenseFileName: _licenseFileName,
          profileImage: _profileImage,
          profileImageName: _profileImageName,
        ));
        // Restore form state after error
        emit(DoctorApplicationFormUpdated(
          gender: _gender,
          specialist: _specialist,
          licenseFile: _licenseFile,
          licenseFileName: _licenseFileName,
          profileImage: _profileImage,
          profileImageName: _profileImageName,
        ));
        return;
      }

      // Create doctor model with password and confirmPassword
      final doctor = DoctorModel(
        name: event.name,
        place: event.place,
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword, // Added confirmPassword
        phone: event.phone,
        gender: event.gender,
        specialist: event.specialist,
        bio: event.bio,
        licenseNumber: event.licenseNumber,
        experience: event.experience,
      );
      
      // Submit to repository (handles Firebase + Cloudinary)
      final doctorId = await _repository.submitDoctorApplication(
        doctor: doctor,
        licenseFile: event.licenseFile,
        profileImage: event.profileImage,
      );
      
      emit(DoctorApplicationSuccess(
        'Application submitted successfully!',
        doctorId,
      ));
    } catch (e) {
      emit(DoctorApplicationFailure(
        e.toString(),
        gender: _gender,
        specialist: _specialist,
        licenseFile: _licenseFile,
        licenseFileName: _licenseFileName,
        profileImage: _profileImage,
        profileImageName: _profileImageName,
      ));
      // Restore form state after error
      emit(DoctorApplicationFormUpdated(
        gender: _gender,
        specialist: _specialist,
        licenseFile: _licenseFile,
        licenseFileName: _licenseFileName,
        profileImage: _profileImage,
        profileImageName: _profileImageName,
      ));
    }
  }

  void _onResetApplication(ResetApplicationEvent event, Emitter<DoctorApplicationState> emit) {
    _gender = null;
    _specialist = null;
    _licenseFile = null;
    _licenseFileName = null;
    _profileImage = null;
    _profileImageName = null;
    
    emit(DoctorApplicationInitial());
  }
}