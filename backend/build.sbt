

lazy val root = (project in file("."))
  .settings(
    organization := "test",
    name := "flutter-test",
    version := "1.0-SNAPSHOT",
    scalaVersion := "2.12.4",
    libraryDependencies ++= Seq(
      guice,
      "org.scalatestplus.play" %% "scalatestplus-play" % "3.1.2" % Test,

      "io.circe" %% "circe-core" % "0.9.3",
      "io.circe" %% "circe-parser" % "0.9.3",
      "io.circe" %% "circe-generic" % "0.9.3",

      "mysql" % "mysql-connector-java" % "8.0.11",

      "com.typesafe.play" %% "play-slick" % "3.0.0",
      "com.typesafe.play" %% "play-slick-evolutions" % "3.0.0"
    )
).enablePlugins(PlayScala)


// Adds additional packages into Twirl
//TwirlKeys.templateImports += "test.controllers._"

// Adds additional packages into conf/routes
// play.sbt.routes.RoutesKeys.routesImport += "test.binders._"
