
// =====================================================================================================================
// = Metadata
// =====================================================================================================================
name := githb_test"
version := "1.2.3"
organization := "aaa.bbb"
scalaVersion := "2.12.11"

lazy val root = project in file("")

// Remove feature warning
// Doc: http://stackoverflow.com/questions/27895790/sbt-0-12-4-there-were-x-feature-warnings-re-run-with-feature-for-details
scalacOptions in ThisBuild ++= Seq("-feature")

// =====================================================================================================================
// = Unit Test Settings
// =====================================================================================================================
parallelExecution in Test := false // Execute unit tests one by one
logBuffered in Test := false

