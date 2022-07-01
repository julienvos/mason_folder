// create a global key to use for for snackbar messages
// this is a constant key so no need for state management
// this key is used in scaffoldMessengerKey (materialApp)

import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();
