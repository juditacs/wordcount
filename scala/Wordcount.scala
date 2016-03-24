import scala.io.StdIn.readLine

object Wordcount {
  def main(args: Array[String]): Unit = {
    val lines = Iterator.continually(readLine()).takeWhile(_ != null)

    val words = for (l <- lines; w <- l.split("\\s+")) yield w

    val map = collection.mutable.Map[String, Int]().withDefaultValue(0)

    words.foreach(w => map.update(w, map(w) - 1))
    map -= ""

    map.toVector.sortBy(x => (x._2, x._1) ).foreach(x => println(s"${x._1}\t${-x._2}"))


  }
}