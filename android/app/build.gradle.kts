plugins {
    id("com.android.application") version "8.7.0"
    id("kotlin-android") version "1.8.0"
    id("dev.flutter.flutter-gradle-plugin")
    id("org.jetbrains.kotlin.android") version "1.x.x"
}

    android {
        compileSdkVersion(33)  // Exemple
        defaultConfig {
            applicationId = "com.example.votreapp"
            minSdkVersion(21)
            targetSdkVersion(34)  // Ici, vous modifiez cette ligne
            versionCode = 1
            versionName = "1.0"
        }

        compileOptions {
            sourceCompatibility = JavaVersion.VERSION_1_8
            targetCompatibility = JavaVersion.VERSION_1_8
            isCoreLibraryDesugaringEnabled = true // Activation du desugaring
        }

        packagingOptions {
            resources {
                excludes += "META-INF/gradle/incremental.annotation.processing.lock"
            }
            jniLibs {
                excludes += "lib/some-lib.so"
            }
        }

        kotlinOptions {
            jvmTarget = JavaVersion.VERSION_11.toString()
        }

        defaultConfig {
            applicationId = "com.example.acces_camera"
            minSdk = 21
            targetSdk = 34
            versionCode = 1
            versionName = "1.0"
        }
        buildTypes {
            release {
                isMinifyEnabled = false
                proguardFiles(
                    getDefaultProguardFile("proguard-android-optimize.txt"),
                    "proguard-rules.pro"
                )
            }
        }
    }

    dependencies {
        // Ajout de la dépendance desugar_jdk_libs pour activer le desugaring
        implementation("com.android.tools:desugar_jdk_libs:2.0.4")
        implementation("androidx.core:core-ktx:1.12.0")
        implementation("androidx.appcompat:appcompat:1.6.1")
        implementation("com.google.android.material:material:1.10.0")
        implementation("org.jetbrains.kotlin:kotlin-stdlib:1.5.0")
        implementation("androidx.constraintlayout:constraintlayout:2.1.4")
    }
