package models

import io.circe._
import io.circe.generic.semiauto._

object UserRequest {
  implicit val dec: Decoder[UserRequest] = deriveDecoder
  implicit val enc: ObjectEncoder[UserRequest] = deriveEncoder
}

case class UserRequest (
                       username: String,
                       password: String
                       )
