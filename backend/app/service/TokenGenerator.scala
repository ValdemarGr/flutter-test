package service

object TokenGenerator {
  def generateToken(seed: String) = seed + "tokenized"
}
