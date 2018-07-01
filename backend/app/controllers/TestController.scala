package controllers

import akka.actor.ActorSystem
import javax.inject._
import models.{UserM, UserRequest}
import play.api.db.slick.{DatabaseConfigProvider, HasDatabaseConfigProvider}
import play.api.mvc._
import schema.UserS
import service.TokenGenerator
import slick.jdbc.JdbcProfile

import scala.concurrent.{ExecutionContext, Future}
import scala.util.{Failure, Success}

@Singleton
class TestController @Inject()  (cc: ControllerComponents,
                                 actorSystem: ActorSystem,
                                 protected val dbConfigProvider: DatabaseConfigProvider)
                                (implicit exec: ExecutionContext)
  extends AbstractController(cc)
    with HasDatabaseConfigProvider[JdbcProfile]{
  import dbConfig.profile.api._

  def succeed = Action.async { implicit req =>
    Future.successful(Ok("Success!"))
  }

  def fail = Action.async { implicit req =>
    Future.successful(Ok(""))
  }

  def login = Action.async { implicit req =>
    import io.circe.parser._
    import io.circe.syntax._

    req.body.asText match {
      case None => badLogin
      case Some(json) => {
        decode[UserRequest](json) match {
          case Left(e) => {
            e.printStackTrace()
            badLogin
          }
          case Right(userRequest) => {
            db.run(UserS.users.filter(_.username === userRequest.username).filter(_.password === userRequest.password).result.headOption).flatMap{
              case None => badLogin
              case Some(_) => Future.successful(Ok(TokenGenerator.generateToken("some token ")))
            }
          }
        }
      }
    }
  }

  def register = Action.async { implicit req =>
    import io.circe.parser._
    import io.circe.syntax._

    req.body.asText match {
      case None => badRegister
      case Some(json) => {
        decode[UserRequest](json) match {
          case Left(e) => {
            e.printStackTrace()
            badRegister
          }
          case Right(userRequest) => {
            db.run(UserS.users.filter(_.username === userRequest.username).result.headOption).flatMap{
              case Some(_) => badRegister
              case None => {
                db.run(DBIO.seq(UserS.users += UserM(0, userRequest.username, userRequest.password))).map { u =>
                  Ok("Register successful!")
                }
              }
            }
          }
        }
      }
    }
  }

  private def badLogin = Future.successful(Ok("Bad login request."))
  private def badRegister = Future.successful(Ok("Failed to register!"))

}
