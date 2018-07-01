package schema

import models.UserM
import slick.jdbc.MySQLProfile.api._

class UserS(tag: Tag) extends Table[UserM](tag, "users") {
  def id = column[Int]("id", O.PrimaryKey, O.AutoInc)
  def username = column[String]("username")
  def password = column[String]("password")
  def * = (id, username, password) <> (UserM.tupled, UserM.unapply)
}

object UserS {
  val users = TableQuery[UserS]
}
