plugins {
    kotlin("jvm") version "1.5.31"
    application
}

group = "org.example"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    implementation(kotlin("stdlib"))
    implementation("it.unibo.tuprolog.argumentation:arg2p-jvm:0.6.1")
    implementation("it.unibo.tuprolog:solve-classic-jvm:0.20.1")
    implementation("it.unibo.tuprolog:parser-theory-jvm:0.20.1")
}

application {
    mainClass.set("Main")
}
