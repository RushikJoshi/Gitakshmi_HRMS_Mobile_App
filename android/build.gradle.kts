allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    fun configureSubproject(proj: Project) {
        val android = proj.extensions.findByName("android") as? com.android.build.gradle.BaseExtension
        if (android != null) {
            android.compileSdkVersion(36)
        }
        
        proj.tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            val target = android?.compileOptions?.targetCompatibility
            if (target != null) {
                val jvmTargetStr = when (target.toString()) {
                    "1.8" -> "JVM_1_8"
                    "8" -> "JVM_1_8"
                    "11" -> "JVM_11"
                    "17" -> "JVM_17"
                    "21" -> "JVM_21"
                    else -> "JVM_11"
                }
                compilerOptions {
                    jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.valueOf(jvmTargetStr))
                }
            }
        }
    }
    
    if (project.state.executed) {
        configureSubproject(project)
    } else {
        project.afterEvaluate {
            configureSubproject(this)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
