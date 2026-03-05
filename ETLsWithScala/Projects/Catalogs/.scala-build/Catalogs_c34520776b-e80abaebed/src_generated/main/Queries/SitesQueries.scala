package Queries


final class SitesQueries$_ {
def args = SitesQueries_sc.args$
def scriptPath = """Queries/SitesQueries.sc"""
/*<script>*/
/*******************************************************************************
* Sites Queries 
* Carlos Kassab -- 2025-December-28
********************************************************************************/


val selectQuery = "SELECT ID AS SiteID, SITE, DESCRIPTION FROM PUBLIC.SITES;"

// Truncate target table.
val truncateQuery = "DELETE FROM CAT_Sites WHERE SiteID !=0"

/*</script>*/ /*<generated>*//*</generated>*/
}

object SitesQueries_sc {
  private var args$opt0 = Option.empty[Array[String]]
  def args$set(args: Array[String]): Unit = {
    args$opt0 = Some(args)
  }
  def args$opt: Option[Array[String]] = args$opt0
  def args$: Array[String] = args$opt.getOrElse {
    sys.error("No arguments passed to this script")
  }

  lazy val script = new SitesQueries$_

  def main(args: Array[String]): Unit = {
    args$set(args)
    val _ = script.hashCode() // hashCode to clear scalac warning about pure expression in statement position
  }
}

export SitesQueries_sc.script as `SitesQueries`

