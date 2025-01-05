// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Crowd Sourcing to Find and Report Water Quality Parameters`
  String get crowd_sourcing {
    return Intl.message(
      'Crowd Sourcing to Find and Report Water Quality Parameters',
      name: 'crowd_sourcing',
      desc: '',
      args: [],
    );
  }

  /// `About NEER?`
  String get aboutNeer {
    return Intl.message(
      'About NEER?',
      name: 'aboutNeer',
      desc: '',
      args: [],
    );
  }

  /// `Project NEER was conceived by Department of Computer Science, Gujarat University under intellectual guidance from Space Application Centre (SAC), Indian Space Research Organisation (ISRO). The project is sponsored by Department of Science and Technology (DST), India for the year 2021-2024. The main objective of the project is to exploit the power of Citizen Science tools in monitoring water bodies and managing water resources division support system.`
  String get projectNeerDescription {
    return Intl.message(
      'Project NEER was conceived by Department of Computer Science, Gujarat University under intellectual guidance from Space Application Centre (SAC), Indian Space Research Organisation (ISRO). The project is sponsored by Department of Science and Technology (DST), India for the year 2021-2024. The main objective of the project is to exploit the power of Citizen Science tools in monitoring water bodies and managing water resources division support system.',
      name: 'projectNeerDescription',
      desc: '',
      args: [],
    );
  }

  /// `What are the parameters used?`
  String get parametersUsed {
    return Intl.message(
      'What are the parameters used?',
      name: 'parametersUsed',
      desc: '',
      args: [],
    );
  }

  /// `Turbidity, FUI index, chlorophyll, temperature, pH, DO, Conductivity, Secchi depth.`
  String get waterParameters {
    return Intl.message(
      'Turbidity, FUI index, chlorophyll, temperature, pH, DO, Conductivity, Secchi depth.',
      name: 'waterParameters',
      desc: '',
      args: [],
    );
  }

  /// `What does this App do?`
  String get app_description {
    return Intl.message(
      'What does this App do?',
      name: 'app_description',
      desc: '',
      args: [],
    );
  }

  /// `This NEER Application will provide the important information about the water quality parameters of inland water bodies. A registered volunteer now a citizen scientist captures photo of water body and measures chemical properties through instrument. The measured data is sent to a remote server tagged with location of volunteer, date and time of observation. The collected data repository on a hosted server is available for further analysis.`
  String get neer_app_description {
    return Intl.message(
      'This NEER Application will provide the important information about the water quality parameters of inland water bodies. A registered volunteer now a citizen scientist captures photo of water body and measures chemical properties through instrument. The measured data is sent to a remote server tagged with location of volunteer, date and time of observation. The collected data repository on a hosted server is available for further analysis.',
      name: 'neer_app_description',
      desc: '',
      args: [],
    );
  }

  /// `Who are we?`
  String get who_are_we {
    return Intl.message(
      'Who are we?',
      name: 'who_are_we',
      desc: '',
      args: [],
    );
  }

  /// `We are a collaborative workgroup of scientists (SAC), professors (Gujarat University), research scholars and citizen scientists working collectively on the major water issues.`
  String get collaborative_workgroup {
    return Intl.message(
      'We are a collaborative workgroup of scientists (SAC), professors (Gujarat University), research scholars and citizen scientists working collectively on the major water issues.',
      name: 'collaborative_workgroup',
      desc: '',
      args: [],
    );
  }

  /// `How to Proceed?`
  String get how_to_proceed {
    return Intl.message(
      'How to Proceed?',
      name: 'how_to_proceed',
      desc: '',
      args: [],
    );
  }

  /// `Click the “Let’s get started” button to move on to the user information page. Continue to set the location, Select the water body and enter the information manually. Images of water, Gray card and sky are taken for Turbidity, chlorophyll and FUI index estimation. Be sure to touch the save button on the bottom of each page. Individual page instructs that how to proceed to next. The final tab helps to submit the user data.`
  String get click_get_started {
    return Intl.message(
      'Click the “Let’s get started” button to move on to the user information page. Continue to set the location, Select the water body and enter the information manually. Images of water, Gray card and sky are taken for Turbidity, chlorophyll and FUI index estimation. Be sure to touch the save button on the bottom of each page. Individual page instructs that how to proceed to next. The final tab helps to submit the user data.',
      name: 'click_get_started',
      desc: '',
      args: [],
    );
  }

  /// `How will we use this data?`
  String get how_will_we_use_this_data {
    return Intl.message(
      'How will we use this data?',
      name: 'how_will_we_use_this_data',
      desc: '',
      args: [],
    );
  }

  /// `The collected data will be used to analyze the water quality and improve the monitoring processes. This data helps in understanding water quality parameters and managing water resources effectively.`
  String get collected_data_usage {
    return Intl.message(
      'The collected data will be used to analyze the water quality and improve the monitoring processes. This data helps in understanding water quality parameters and managing water resources effectively.',
      name: 'collected_data_usage',
      desc: '',
      args: [],
    );
  }

  /// `LET'S GET STARTED!`
  String get lets_get_started {
    return Intl.message(
      'LET\'S GET STARTED!',
      name: 'lets_get_started',
      desc: '',
      args: [],
    );
  }

  /// `NEER`
  String get neer {
    return Intl.message(
      'NEER',
      name: 'neer',
      desc: '',
      args: [],
    );
  }

  /// `WELCOME`
  String get welcome {
    return Intl.message(
      'WELCOME',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `Developed as a part of project 'NEER' funded by DST under 'WTI 2019'`
  String get developed_part_of_project_neer {
    return Intl.message(
      'Developed as a part of project \'NEER\' funded by DST under \'WTI 2019\'',
      name: 'developed_part_of_project_neer',
      desc: '',
      args: [],
    );
  }

  /// `Complete Your Profile`
  String get completeProfile {
    return Intl.message(
      'Complete Your Profile',
      name: 'completeProfile',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message(
      'First Name',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `Institute Name`
  String get instituteName {
    return Intl.message(
      'Institute Name',
      name: 'instituteName',
      desc: '',
      args: [],
    );
  }

  /// `Select State`
  String get selectState {
    return Intl.message(
      'Select State',
      name: 'selectState',
      desc: '',
      args: [],
    );
  }

  /// `Select City`
  String get selectCity {
    return Intl.message(
      'Select City',
      name: 'selectCity',
      desc: '',
      args: [],
    );
  }

  /// `Error: {error}`
  String error(Object error) {
    return Intl.message(
      'Error: $error',
      name: 'error',
      desc: '',
      args: [error],
    );
  }

  /// `Please fill all fields.`
  String get fillAllFields {
    return Intl.message(
      'Please fill all fields.',
      name: 'fillAllFields',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address.`
  String get validEmail {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'validEmail',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect password. Please try again.`
  String get incorrectPassword {
    return Intl.message(
      'Incorrect password. Please try again.',
      name: 'incorrectPassword',
      desc: '',
      args: [],
    );
  }

  /// `Email not found. Please sign up.`
  String get emailNotFound {
    return Intl.message(
      'Email not found. Please sign up.',
      name: 'emailNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Failed to login. Please try again later.`
  String get loginFailed {
    return Intl.message(
      'Failed to login. Please try again later.',
      name: 'loginFailed',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email and password.`
  String get enterEmailPassword {
    return Intl.message(
      'Please enter your email and password.',
      name: 'enterEmailPassword',
      desc: '',
      args: [],
    );
  }

  /// `Signing In`
  String get signingIn {
    return Intl.message(
      'Signing In',
      name: 'signingIn',
      desc: '',
      args: [],
    );
  }

  /// `Please wait while we sign you in...`
  String get pleaseWait {
    return Intl.message(
      'Please wait while we sign you in...',
      name: 'pleaseWait',
      desc: '',
      args: [],
    );
  }

  /// `Sign-In Failed`
  String get signInFailed {
    return Intl.message(
      'Sign-In Failed',
      name: 'signInFailed',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred during sign-in: {error}`
  String signInError(Object error) {
    return Intl.message(
      'An error occurred during sign-in: $error',
      name: 'signInError',
      desc: '',
      args: [error],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `User Information`
  String get userInfo {
    return Intl.message(
      'User Information',
      name: 'userInfo',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Hindi`
  String get hindi {
    return Intl.message(
      'Hindi',
      name: 'hindi',
      desc: '',
      args: [],
    );
  }

  /// `Gujarati`
  String get gujarati {
    return Intl.message(
      'Gujarati',
      name: 'gujarati',
      desc: '',
      args: [],
    );
  }

  /// `Logging in, please wait...`
  String get logging_in_please_wait {
    return Intl.message(
      'Logging in, please wait...',
      name: 'logging_in_please_wait',
      desc: '',
      args: [],
    );
  }

  /// `LOGIN`
  String get login {
    return Intl.message(
      'LOGIN',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `CREATE NEW ACCOUNT`
  String get create_new_account {
    return Intl.message(
      'CREATE NEW ACCOUNT',
      name: 'create_new_account',
      desc: '',
      args: [],
    );
  }

  /// `OR`
  String get or {
    return Intl.message(
      'OR',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Google`
  String get continue_with_google {
    return Intl.message(
      'Continue with Google',
      name: 'continue_with_google',
      desc: '',
      args: [],
    );
  }

  /// `Please select a state`
  String get please_select_a_state {
    return Intl.message(
      'Please select a state',
      name: 'please_select_a_state',
      desc: '',
      args: [],
    );
  }

  /// `Please select a city`
  String get please_select_a_city {
    return Intl.message(
      'Please select a city',
      name: 'please_select_a_city',
      desc: '',
      args: [],
    );
  }

  /// `User with this email already exists!`
  String get user_with_this_email_already_exists {
    return Intl.message(
      'User with this email already exists!',
      name: 'user_with_this_email_already_exists',
      desc: '',
      args: [],
    );
  }

  /// `Failed to submit the form. Please try again later.`
  String get failed_to_submit_form {
    return Intl.message(
      'Failed to submit the form. Please try again later.',
      name: 'failed_to_submit_form',
      desc: '',
      args: [],
    );
  }

  /// `Select a state first`
  String get select_a_state_first {
    return Intl.message(
      'Select a state first',
      name: 'select_a_state_first',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirm_password {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Enter Observation Title`
  String get enter_observation_title {
    return Intl.message(
      'Enter Observation Title',
      name: 'enter_observation_title',
      desc: '',
      args: [],
    );
  }

  /// `Observation Title`
  String get observation_title {
    return Intl.message(
      'Observation Title',
      name: 'observation_title',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid Secchi Depth`
  String get please_enter_valid_secchi_depth {
    return Intl.message(
      'Please enter a valid Secchi Depth',
      name: 'please_enter_valid_secchi_depth',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid numeric value for Secchi Depth`
  String get please_enter_valid_numeric_value_secchi_depth {
    return Intl.message(
      'Please enter a valid numeric value for Secchi Depth',
      name: 'please_enter_valid_numeric_value_secchi_depth',
      desc: '',
      args: [],
    );
  }

  /// `Please enter title for observation`
  String get please_enter_title_for_observation {
    return Intl.message(
      'Please enter title for observation',
      name: 'please_enter_title_for_observation',
      desc: '',
      args: [],
    );
  }

  /// `Unable to fetch location. Please ensure location services are enabled.`
  String get unable_to_fetch_location {
    return Intl.message(
      'Unable to fetch location. Please ensure location services are enabled.',
      name: 'unable_to_fetch_location',
      desc: '',
      args: [],
    );
  }

  /// `Data uploaded successfully!`
  String get data_uploaded_successfully {
    return Intl.message(
      'Data uploaded successfully!',
      name: 'data_uploaded_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Secchi Depth Observation`
  String get secchi_depth_observation {
    return Intl.message(
      'Secchi Depth Observation',
      name: 'secchi_depth_observation',
      desc: '',
      args: [],
    );
  }

  /// `Secchi Depth`
  String get secchi_depth {
    return Intl.message(
      'Secchi Depth',
      name: 'secchi_depth',
      desc: '',
      args: [],
    );
  }

  /// `Enter the depth in (cm)`
  String get enter_depth_in_m {
    return Intl.message(
      'Enter the depth in (cm)',
      name: 'enter_depth_in_m',
      desc: '',
      args: [],
    );
  }

  /// `Instructions to use NEER`
  String get app_title {
    return Intl.message(
      'Instructions to use NEER',
      name: 'app_title',
      desc: '',
      args: [],
    );
  }

  /// `NEER Application is used to determine the water quality in terms of estimation of parameters like FUI Index, Turbidity, Chlorophyll, and SPM values. These parameters are measured through camera clicking, and Temp, pH, Depth, Dissolved Oxygen, Conductivity, and Secchi Depth are manually measured through instruments. Before that, the user has to set the location by GPS or manually, and based on that, Latitude and Longitude values can be easily fetched. After selecting the water body, the user can select the relevant parameters of that corresponding water body. The FUI index calculates the water index color through capturing the image of water. NEER has an easy-to-use interface that guides users through the collection of three images: a gray card image, a sky image, and a water image. NEER requires the use of an 18% photographer’s gray card as a reference. Gray cards are widely available at photography shops and online. Once the images are taken, they can be analyzed immediately. In the analysis of the images, NEER calculates the reflectance of the water body in the RGB color channels of the camera. It then uses the reflectance values to determine the turbidity of the water in NTU (nephelometric turbidity units). The Secchi Disk is a round white disk lowered into the water body to determine the Secchi Depth, which is the depth at which water can no longer be seen from the surface. The Secchi Depth measures the clarity of the water.`
  String get instructions_text {
    return Intl.message(
      'NEER Application is used to determine the water quality in terms of estimation of parameters like FUI Index, Turbidity, Chlorophyll, and SPM values. These parameters are measured through camera clicking, and Temp, pH, Depth, Dissolved Oxygen, Conductivity, and Secchi Depth are manually measured through instruments. Before that, the user has to set the location by GPS or manually, and based on that, Latitude and Longitude values can be easily fetched. After selecting the water body, the user can select the relevant parameters of that corresponding water body. The FUI index calculates the water index color through capturing the image of water. NEER has an easy-to-use interface that guides users through the collection of three images: a gray card image, a sky image, and a water image. NEER requires the use of an 18% photographer’s gray card as a reference. Gray cards are widely available at photography shops and online. Once the images are taken, they can be analyzed immediately. In the analysis of the images, NEER calculates the reflectance of the water body in the RGB color channels of the camera. It then uses the reflectance values to determine the turbidity of the water in NTU (nephelometric turbidity units). The Secchi Disk is a round white disk lowered into the water body to determine the Secchi Depth, which is the depth at which water can no longer be seen from the surface. The Secchi Depth measures the clarity of the water.',
      name: 'instructions_text',
      desc: '',
      args: [],
    );
  }

  /// `Click to Get Location`
  String get button_text {
    return Intl.message(
      'Click to Get Location',
      name: 'button_text',
      desc: '',
      args: [],
    );
  }

  /// `Fetching location, please wait...`
  String get fetching_location_please_wait {
    return Intl.message(
      'Fetching location, please wait...',
      name: 'fetching_location_please_wait',
      desc: '',
      args: [],
    );
  }

  /// `Please turn on location services.`
  String get please_turn_on_location_services {
    return Intl.message(
      'Please turn on location services.',
      name: 'please_turn_on_location_services',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid coordinates!`
  String get please_enter_valid_coordinates {
    return Intl.message(
      'Please enter valid coordinates!',
      name: 'please_enter_valid_coordinates',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Lat:`
  String get lat {
    return Intl.message(
      'Lat:',
      name: 'lat',
      desc: '',
      args: [],
    );
  }

  /// `Latitude`
  String get latitude {
    return Intl.message(
      'Latitude',
      name: 'latitude',
      desc: '',
      args: [],
    );
  }

  /// `Lon`
  String get lon {
    return Intl.message(
      'Lon',
      name: 'lon',
      desc: '',
      args: [],
    );
  }

  /// `Longitude`
  String get longitude {
    return Intl.message(
      'Longitude',
      name: 'longitude',
      desc: '',
      args: [],
    );
  }

  /// `Go to Next`
  String get goto_next {
    return Intl.message(
      'Go to Next',
      name: 'goto_next',
      desc: '',
      args: [],
    );
  }

  /// `Please Select the Ecosystem`
  String get header_title {
    return Intl.message(
      'Please Select the Ecosystem',
      name: 'header_title',
      desc: '',
      args: [],
    );
  }

  /// `Lake`
  String get lake {
    return Intl.message(
      'Lake',
      name: 'lake',
      desc: '',
      args: [],
    );
  }

  /// `Reservoir`
  String get reservoir {
    return Intl.message(
      'Reservoir',
      name: 'reservoir',
      desc: '',
      args: [],
    );
  }

  /// `Wet Land`
  String get wetland {
    return Intl.message(
      'Wet Land',
      name: 'wetland',
      desc: '',
      args: [],
    );
  }

  /// `River/Stream`
  String get river_stream {
    return Intl.message(
      'River/Stream',
      name: 'river_stream',
      desc: '',
      args: [],
    );
  }

  /// `Please Select One WaterBody`
  String get footer_message {
    return Intl.message(
      'Please Select One WaterBody',
      name: 'footer_message',
      desc: '',
      args: [],
    );
  }

  /// `Select Ecosystem`
  String get select_ecosystem {
    return Intl.message(
      'Select Ecosystem',
      name: 'select_ecosystem',
      desc: '',
      args: [],
    );
  }

  /// `Select Parameters`
  String get select_parameters {
    return Intl.message(
      'Select Parameters',
      name: 'select_parameters',
      desc: '',
      args: [],
    );
  }

  /// `Check the boxes/click on icon to select parameters of interest`
  String get check_boxes_instruction {
    return Intl.message(
      'Check the boxes/click on icon to select parameters of interest',
      name: 'check_boxes_instruction',
      desc: '',
      args: [],
    );
  }

  /// `RESET`
  String get reset_button {
    return Intl.message(
      'RESET',
      name: 'reset_button',
      desc: '',
      args: [],
    );
  }

  /// `SUBMIT`
  String get submit_button {
    return Intl.message(
      'SUBMIT',
      name: 'submit_button',
      desc: '',
      args: [],
    );
  }

  /// `Select at least one User Entry.`
  String get select_at_least_one {
    return Intl.message(
      'Select at least one User Entry.',
      name: 'select_at_least_one',
      desc: '',
      args: [],
    );
  }

  /// `Temperature`
  String get temperature {
    return Intl.message(
      'Temperature',
      name: 'temperature',
      desc: '',
      args: [],
    );
  }

  /// `pH`
  String get ph {
    return Intl.message(
      'pH',
      name: 'ph',
      desc: '',
      args: [],
    );
  }

  /// `Water Depth`
  String get water_depth {
    return Intl.message(
      'Water Depth',
      name: 'water_depth',
      desc: '',
      args: [],
    );
  }

  /// `Dissolved O2`
  String get dissolved_o2 {
    return Intl.message(
      'Dissolved O2',
      name: 'dissolved_o2',
      desc: '',
      args: [],
    );
  }

  /// `FUI Index`
  String get fui_index {
    return Intl.message(
      'FUI Index',
      name: 'fui_index',
      desc: '',
      args: [],
    );
  }

  /// `Turbidity`
  String get turbidity {
    return Intl.message(
      'Turbidity',
      name: 'turbidity',
      desc: '',
      args: [],
    );
  }

  /// `In-Situ Observation`
  String get in_situ_observation {
    return Intl.message(
      'In-Situ Observation',
      name: 'in_situ_observation',
      desc: '',
      args: [],
    );
  }

  /// `Saving data, please wait...`
  String get saving_data_please_wait {
    return Intl.message(
      'Saving data, please wait...',
      name: 'saving_data_please_wait',
      desc: '',
      args: [],
    );
  }

  /// `Click To Save`
  String get click_to_save {
    return Intl.message(
      'Click To Save',
      name: 'click_to_save',
      desc: '',
      args: [],
    );
  }

  /// `User email not found!`
  String get user_email_not_found {
    return Intl.message(
      'User email not found!',
      name: 'user_email_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Click the above button to save manually entered values.`
  String get click_to_save_manually_entered_values {
    return Intl.message(
      'Click the above button to save manually entered values.',
      name: 'click_to_save_manually_entered_values',
      desc: '',
      args: [],
    );
  }

  /// `Data saved successfully!`
  String get data_saved_successfully {
    return Intl.message(
      'Data saved successfully!',
      name: 'data_saved_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Instructions for User`
  String get instructions_for_user {
    return Intl.message(
      'Instructions for User',
      name: 'instructions_for_user',
      desc: '',
      args: [],
    );
  }

  /// `Guidelines to Calculate Turbidity`
  String get guidelines_to_calculate_turbidity {
    return Intl.message(
      'Guidelines to Calculate Turbidity',
      name: 'guidelines_to_calculate_turbidity',
      desc: '',
      args: [],
    );
  }

  /// `1. Capture the image of Gray Card, Water, and Sky with instructed angles.`
  String get capture_image_instruction_1 {
    return Intl.message(
      '1. Capture the image of Gray Card, Water, and Sky with instructed angles.',
      name: 'capture_image_instruction_1',
      desc: '',
      args: [],
    );
  }

  /// `2. Analyze the calculated Results.`
  String get analyze_results_instruction_2 {
    return Intl.message(
      '2. Analyze the calculated Results.',
      name: 'analyze_results_instruction_2',
      desc: '',
      args: [],
    );
  }

  /// `3. Visualize the histogram images of Gray Card, Water, and Sky images.`
  String get visualize_histogram_instruction_3 {
    return Intl.message(
      '3. Visualize the histogram images of Gray Card, Water, and Sky images.',
      name: 'visualize_histogram_instruction_3',
      desc: '',
      args: [],
    );
  }

  /// `4. Visualize the Results with Proper Location, Date, and Time.`
  String get visualize_results_instruction_4 {
    return Intl.message(
      '4. Visualize the Results with Proper Location, Date, and Time.',
      name: 'visualize_results_instruction_4',
      desc: '',
      args: [],
    );
  }

  /// `5. For Gray Card the angle must be between 35 and 45 degrees to take picture.`
  String get gray_card_angle_instruction_5 {
    return Intl.message(
      '5. For Gray Card the angle must be between 35 and 45 degrees to take picture.',
      name: 'gray_card_angle_instruction_5',
      desc: '',
      args: [],
    );
  }

  /// `6. For Water the angle must be between 35 and 45 degrees to take picture.`
  String get water_angle_instruction_6 {
    return Intl.message(
      '6. For Water the angle must be between 35 and 45 degrees to take picture.',
      name: 'water_angle_instruction_6',
      desc: '',
      args: [],
    );
  }

  /// `7. For Sky the angle must be between 125 and 135 degrees to take picture.`
  String get sky_angle_instruction_7 {
    return Intl.message(
      '7. For Sky the angle must be between 125 and 135 degrees to take picture.',
      name: 'sky_angle_instruction_7',
      desc: '',
      args: [],
    );
  }

  /// `Proceed`
  String get proceed {
    return Intl.message(
      'Proceed',
      name: 'proceed',
      desc: '',
      args: [],
    );
  }

  /// `Use Default Gray Card Image?`
  String get use_default_gray_card_image {
    return Intl.message(
      'Use Default Gray Card Image?',
      name: 'use_default_gray_card_image',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Analyzing`
  String get analyzing {
    return Intl.message(
      'Analyzing',
      name: 'analyzing',
      desc: '',
      args: [],
    );
  }

  /// `Preview Images`
  String get preview_images {
    return Intl.message(
      'Preview Images',
      name: 'preview_images',
      desc: '',
      args: [],
    );
  }

  /// `Capture`
  String get capture {
    return Intl.message(
      'Capture',
      name: 'capture',
      desc: '',
      args: [],
    );
  }

  /// `Captured Images Preview`
  String get captured_images_preview {
    return Intl.message(
      'Captured Images Preview',
      name: 'captured_images_preview',
      desc: '',
      args: [],
    );
  }

  /// `No image captured for {label}`
  String no_image_captured(Object label) {
    return Intl.message(
      'No image captured for $label',
      name: 'no_image_captured',
      desc: '',
      args: [label],
    );
  }

  /// `Analysis Results`
  String get analysis_results {
    return Intl.message(
      'Analysis Results',
      name: 'analysis_results',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get upload {
    return Intl.message(
      'Upload',
      name: 'upload',
      desc: '',
      args: [],
    );
  }

  /// `Data Saved!`
  String get data_saved {
    return Intl.message(
      'Data Saved!',
      name: 'data_saved',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Data already uploaded!`
  String get data_already_uploaded {
    return Intl.message(
      'Data already uploaded!',
      name: 'data_already_uploaded',
      desc: '',
      args: [],
    );
  }

  /// `Data already saved!`
  String get data_already_saved {
    return Intl.message(
      'Data already saved!',
      name: 'data_already_saved',
      desc: '',
      args: [],
    );
  }

  /// `Histogram`
  String get histogram {
    return Intl.message(
      'Histogram',
      name: 'histogram',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `SPM`
  String get spm {
    return Intl.message(
      'SPM',
      name: 'spm',
      desc: '',
      args: [],
    );
  }

  /// `Ref. Red`
  String get ref_red {
    return Intl.message(
      'Ref. Red',
      name: 'ref_red',
      desc: '',
      args: [],
    );
  }

  /// `Ref. Green`
  String get ref_green {
    return Intl.message(
      'Ref. Green',
      name: 'ref_green',
      desc: '',
      args: [],
    );
  }

  /// `Ref. Blue`
  String get ref_blue {
    return Intl.message(
      'Ref. Blue',
      name: 'ref_blue',
      desc: '',
      args: [],
    );
  }

  /// `Image Histogram`
  String get image_histogram {
    return Intl.message(
      'Image Histogram',
      name: 'image_histogram',
      desc: '',
      args: [],
    );
  }

  /// `Gray Card`
  String get gray_card {
    return Intl.message(
      'Gray Card',
      name: 'gray_card',
      desc: '',
      args: [],
    );
  }

  /// `Water`
  String get water {
    return Intl.message(
      'Water',
      name: 'water',
      desc: '',
      args: [],
    );
  }

  /// `Sky`
  String get sky {
    return Intl.message(
      'Sky',
      name: 'sky',
      desc: '',
      args: [],
    );
  }

  /// `Red Histogram`
  String get red_histogram {
    return Intl.message(
      'Red Histogram',
      name: 'red_histogram',
      desc: '',
      args: [],
    );
  }

  /// `Green Histogram`
  String get green_histogram {
    return Intl.message(
      'Green Histogram',
      name: 'green_histogram',
      desc: '',
      args: [],
    );
  }

  /// `Blue Histogram`
  String get blue_histogram {
    return Intl.message(
      'Blue Histogram',
      name: 'blue_histogram',
      desc: '',
      args: [],
    );
  }

  /// `Capture Image`
  String get capture_image {
    return Intl.message(
      'Capture Image',
      name: 'capture_image',
      desc: '',
      args: [],
    );
  }

  /// `Observation Data`
  String get observation_data_title {
    return Intl.message(
      'Observation Data',
      name: 'observation_data_title',
      desc: '',
      args: [],
    );
  }

  /// `Start Date`
  String get start_date {
    return Intl.message(
      'Start Date',
      name: 'start_date',
      desc: '',
      args: [],
    );
  }

  /// `End Date`
  String get end_date {
    return Intl.message(
      'End Date',
      name: 'end_date',
      desc: '',
      args: [],
    );
  }

  /// `Select Date`
  String get select_date {
    return Intl.message(
      'Select Date',
      name: 'select_date',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter_button {
    return Intl.message(
      'Filter',
      name: 'filter_button',
      desc: '',
      args: [],
    );
  }

  /// `Delete Observation`
  String get delete_observation {
    return Intl.message(
      'Delete Observation',
      name: 'delete_observation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this observation?`
  String get delete_confirmation {
    return Intl.message(
      'Are you sure you want to delete this observation?',
      name: 'delete_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel_button {
    return Intl.message(
      'Cancel',
      name: 'cancel_button',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete_button {
    return Intl.message(
      'Delete',
      name: 'delete_button',
      desc: '',
      args: [],
    );
  }

  /// `UNDO`
  String get undo_button {
    return Intl.message(
      'UNDO',
      name: 'undo_button',
      desc: '',
      args: [],
    );
  }

  /// `Observation deleted`
  String get observation_deleted {
    return Intl.message(
      'Observation deleted',
      name: 'observation_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Observation restored`
  String get observation_restored {
    return Intl.message(
      'Observation restored',
      name: 'observation_restored',
      desc: '',
      args: [],
    );
  }

  /// `No observations taken.`
  String get no_observations {
    return Intl.message(
      'No observations taken.',
      name: 'no_observations',
      desc: '',
      args: [],
    );
  }

  /// `Reflectance Red`
  String get reflectance_red {
    return Intl.message(
      'Reflectance Red',
      name: 'reflectance_red',
      desc: '',
      args: [],
    );
  }

  /// `Reflectance Green`
  String get reflectance_green {
    return Intl.message(
      'Reflectance Green',
      name: 'reflectance_green',
      desc: '',
      args: [],
    );
  }

  /// `Reflectance Blue`
  String get reflectance_blue {
    return Intl.message(
      'Reflectance Blue',
      name: 'reflectance_blue',
      desc: '',
      args: [],
    );
  }

  /// `Reflectance`
  String get reflectance {
    return Intl.message(
      'Reflectance',
      name: 'reflectance',
      desc: '',
      args: [],
    );
  }

  /// `Ph Value`
  String get ph_value {
    return Intl.message(
      'Ph Value',
      name: 'ph_value',
      desc: '',
      args: [],
    );
  }

  /// `Water`
  String get waterButtonText {
    return Intl.message(
      'Water',
      name: 'waterButtonText',
      desc: 'Text for the \'Water\' button',
      args: [],
    );
  }

  /// `New Measurement`
  String get newMeasurementButtonText {
    return Intl.message(
      'New Measurement',
      name: 'newMeasurementButtonText',
      desc: 'Text for the \'New Measurement\' button',
      args: [],
    );
  }

  /// `0.00`
  String get defaultPitchValue {
    return Intl.message(
      '0.00',
      name: 'defaultPitchValue',
      desc: 'Default value for pitch angle display',
      args: [],
    );
  }

  /// `Color Details`
  String get color_details_title {
    return Intl.message(
      'Color Details',
      name: 'color_details_title',
      desc: '',
      args: [],
    );
  }

  /// `Color Information: {label}`
  String color_info_label(Object label) {
    return Intl.message(
      'Color Information: $label',
      name: 'color_info_label',
      desc: '',
      args: [label],
    );
  }

  /// `X: `
  String get x_label {
    return Intl.message(
      'X: ',
      name: 'x_label',
      desc: '',
      args: [],
    );
  }

  /// `Y: `
  String get y_label {
    return Intl.message(
      'Y: ',
      name: 'y_label',
      desc: '',
      args: [],
    );
  }

  /// `Corrected Angle: `
  String get corrected_angle_label {
    return Intl.message(
      'Corrected Angle: ',
      name: 'corrected_angle_label',
      desc: '',
      args: [],
    );
  }

  /// `Angle: `
  String get angle_label {
    return Intl.message(
      'Angle: ',
      name: 'angle_label',
      desc: '',
      args: [],
    );
  }

  /// `Results`
  String get results_title {
    return Intl.message(
      'Results',
      name: 'results_title',
      desc: '',
      args: [],
    );
  }

  /// `Triangle Value: {value}`
  String triangle_value(Object value) {
    return Intl.message(
      'Triangle Value: $value',
      name: 'triangle_value',
      desc: '',
      args: [value],
    );
  }

  /// `X Value: {value}`
  String x_value(Object value) {
    return Intl.message(
      'X Value: $value',
      name: 'x_value',
      desc: '',
      args: [value],
    );
  }

  /// `Y Value: {value}`
  String y_value(Object value) {
    return Intl.message(
      'Y Value: $value',
      name: 'y_value',
      desc: '',
      args: [value],
    );
  }

  /// `Angle Value: {value}`
  String angle_value(Object value) {
    return Intl.message(
      'Angle Value: $value',
      name: 'angle_value',
      desc: '',
      args: [value],
    );
  }

  /// `Corrected Angle: {value}`
  String corrected_angle(Object value) {
    return Intl.message(
      'Corrected Angle: $value',
      name: 'corrected_angle',
      desc: '',
      args: [value],
    );
  }

  /// `Loading...`
  String get loading_indicator {
    return Intl.message(
      'Loading...',
      name: 'loading_indicator',
      desc: '',
      args: [],
    );
  }

  /// `Failed to save data: {error}`
  String data_save_failed(Object error) {
    return Intl.message(
      'Failed to save data: $error',
      name: 'data_save_failed',
      desc: '',
      args: [error],
    );
  }

  /// `Instructions to Use FUI Index`
  String get appBarTitle {
    return Intl.message(
      'Instructions to Use FUI Index',
      name: 'appBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Capture the photo of the waterbody by clicking the proceed button and enter the index value.`
  String get instruction1 {
    return Intl.message(
      'Capture the photo of the waterbody by clicking the proceed button and enter the index value.',
      name: 'instruction1',
      desc: '',
      args: [],
    );
  }

  /// `Calculate the FUI index value from the image capture and verify.`
  String get instruction2 {
    return Intl.message(
      'Calculate the FUI index value from the image capture and verify.',
      name: 'instruction2',
      desc: '',
      args: [],
    );
  }

  /// `Click to Get Proceed`
  String get buttonText {
    return Intl.message(
      'Click to Get Proceed',
      name: 'buttonText',
      desc: '',
      args: [],
    );
  }

  /// `Select Water Colour`
  String get gridScreenTitle {
    return Intl.message(
      'Select Water Colour',
      name: 'gridScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Image you captured`
  String get imageCaptured {
    return Intl.message(
      'Image you captured',
      name: 'imageCaptured',
      desc: '',
      args: [],
    );
  }

  /// `Select Water Colour`
  String get selectWaterColour {
    return Intl.message(
      'Select Water Colour',
      name: 'selectWaterColour',
      desc: '',
      args: [],
    );
  }

  /// `SUBMIT`
  String get submitButton {
    return Intl.message(
      'SUBMIT',
      name: 'submitButton',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Selection`
  String get invalidSelectionTitle {
    return Intl.message(
      'Invalid Selection',
      name: 'invalidSelectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please select exactly 1 color.`
  String get invalidSelectionMessage {
    return Intl.message(
      'Please select exactly 1 color.',
      name: 'invalidSelectionMessage',
      desc: '',
      args: [],
    );
  }

  /// `You can only select 1 color.`
  String get snackBarMessage {
    return Intl.message(
      'You can only select 1 color.',
      name: 'snackBarMessage',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get helpScreenTitle {
    return Intl.message(
      'Help',
      name: 'helpScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `HOW TO USE IT:`
  String get howToUse {
    return Intl.message(
      'HOW TO USE IT:',
      name: 'howToUse',
      desc: '',
      args: [],
    );
  }

  /// `1. Capture 3 images:`
  String get instruction1_1 {
    return Intl.message(
      '1. Capture 3 images:',
      name: 'instruction1_1',
      desc: '',
      args: [],
    );
  }

  /// `(i) Photographer’s 18% gray card`
  String get subInstruction1 {
    return Intl.message(
      '(i) Photographer’s 18% gray card',
      name: 'subInstruction1',
      desc: '',
      args: [],
    );
  }

  /// `(ii) Water image`
  String get subInstruction2 {
    return Intl.message(
      '(ii) Water image',
      name: 'subInstruction2',
      desc: '',
      args: [],
    );
  }

  /// `(iii) Sky image`
  String get subInstruction3 {
    return Intl.message(
      '(iii) Sky image',
      name: 'subInstruction3',
      desc: '',
      args: [],
    );
  }

  /// `2. When capturing images, make sure the sun position is left side or right side behind you, but not in front of you.`
  String get instruction2_2 {
    return Intl.message(
      '2. When capturing images, make sure the sun position is left side or right side behind you, but not in front of you.',
      name: 'instruction2_2',
      desc: '',
      args: [],
    );
  }

  /// `3. The gray card is a piece of paper or cardboard with a known 18% reflectance value (similar to Kodak’s 18% reflectance). They can be purchased at photography shops or online.`
  String get instruction3 {
    return Intl.message(
      '3. The gray card is a piece of paper or cardboard with a known 18% reflectance value (similar to Kodak’s 18% reflectance). They can be purchased at photography shops or online.',
      name: 'instruction3',
      desc: '',
      args: [],
    );
  }

  /// `4. The first image you need to collect is the photographer's gray card. Place the card on a level surface that is unsaturated. Be sure the card is in an unsaturated area where you plan to take the water image.`
  String get instruction4 {
    return Intl.message(
      '4. The first image you need to collect is the photographer\'s gray card. Place the card on a level surface that is unsaturated. Be sure the card is in an unsaturated area where you plan to take the water image.',
      name: 'instruction4',
      desc: '',
      args: [],
    );
  }

  /// `5. Ensure your shadow is not covering the card.`
  String get instruction5 {
    return Intl.message(
      '5. Ensure your shadow is not covering the card.',
      name: 'instruction5',
      desc: '',
      args: [],
    );
  }

  /// `6. The angle of the mobile for image of gray card and water must be 35 to 55 degrees, and for sky, the angle must be 125 to 135 degrees.`
  String get instruction6 {
    return Intl.message(
      '6. The angle of the mobile for image of gray card and water must be 35 to 55 degrees, and for sky, the angle must be 125 to 135 degrees.',
      name: 'instruction6',
      desc: '',
      args: [],
    );
  }

  /// `7. A clinometer at the bottom will direct you to the correct angle to take the photograph. When the angle is correct, the circle will become full, and the border of the blue bubble will be red.`
  String get instruction7 {
    return Intl.message(
      '7. A clinometer at the bottom will direct you to the correct angle to take the photograph. When the angle is correct, the circle will become full, and the border of the blue bubble will be red.',
      name: 'instruction7',
      desc: '',
      args: [],
    );
  }

  /// `8. For best results, use NIR if the present areas are accessible. If the bottom areas shrink, this area is too shallow to be NIR.`
  String get instruction8 {
    return Intl.message(
      '8. For best results, use NIR if the present areas are accessible. If the bottom areas shrink, this area is too shallow to be NIR.',
      name: 'instruction8',
      desc: '',
      args: [],
    );
  }

  /// `9. After capturing all three images, the analysis button will calculate and display the reflectance data.`
  String get instruction9 {
    return Intl.message(
      '9. After capturing all three images, the analysis button will calculate and display the reflectance data.',
      name: 'instruction9',
      desc: '',
      args: [],
    );
  }

  /// `10. The images are saved in your mobile’s NIR folder.`
  String get instruction10 {
    return Intl.message(
      '10. The images are saved in your mobile’s NIR folder.',
      name: 'instruction10',
      desc: '',
      args: [],
    );
  }

  /// `11. You can also see the Histogram of all images.`
  String get instruction11 {
    return Intl.message(
      '11. You can also see the Histogram of all images.',
      name: 'instruction11',
      desc: '',
      args: [],
    );
  }

  /// `12. You can save the data locally and also upload it to the server.`
  String get instruction12 {
    return Intl.message(
      '12. You can save the data locally and also upload it to the server.',
      name: 'instruction12',
      desc: '',
      args: [],
    );
  }

  /// `13. The result button will display all previous records. You can filter all results based on your choice.`
  String get instruction13 {
    return Intl.message(
      '13. The result button will display all previous records. You can filter all results based on your choice.',
      name: 'instruction13',
      desc: '',
      args: [],
    );
  }

  /// `14. For new measurement, click on “new measurement button.”`
  String get instruction14 {
    return Intl.message(
      '14. For new measurement, click on “new measurement button.”',
      name: 'instruction14',
      desc: '',
      args: [],
    );
  }

  /// `15. You can enter latitude and longitude for your options and also touch on the map to zoom.`
  String get instruction15 {
    return Intl.message(
      '15. You can enter latitude and longitude for your options and also touch on the map to zoom.',
      name: 'instruction15',
      desc: '',
      args: [],
    );
  }

  /// `16. Similarly, TUI index calculates the index color through capturing the image of water and the Secchi depth measures the clarity of water.`
  String get instruction16 {
    return Intl.message(
      '16. Similarly, TUI index calculates the index color through capturing the image of water and the Secchi depth measures the clarity of water.',
      name: 'instruction16',
      desc: '',
      args: [],
    );
  }

  /// `CLOSE`
  String get closeButton {
    return Intl.message(
      'CLOSE',
      name: 'closeButton',
      desc: '',
      args: [],
    );
  }

  /// `Chlorophyll`
  String get chlorophyll {
    return Intl.message(
      'Chlorophyll',
      name: 'chlorophyll',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'gu'),
      Locale.fromSubtags(languageCode: 'hi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
