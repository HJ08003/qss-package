#' 2008 US Presidential State Polls Data
#'
#' Polling data for each state for 2008 United States Presidential Election.
#'
#' @format A data frame with 1332 rows and 5 variables:
#' \describe{
#'  \item{ state }{ character: abbreviated name of the state in which the poll was conducted }
#'  \item{ Pollster }{ character: name of the organization conducting the poll }
#'  \item{ Obama }{ integer: predicted support for Obama (percentage) }
#'  \item{ McCain }{ integer: predicted support for McCain (percentage) }
#'  \item{ middate }{ Date: middate of the period when the poll was conducted }
#' }
#'
#'
#' @details
#' See \emph{QSS} Table 4.2.
#'
#'
#' @references
#' \itemize{
#' \item{ Imai, Kosuke. 2017. \emph{Quantitative Social Science: An Introduction}.
#' Princeton University Press. \href{http://press.princeton.edu/titles/11025.html}{URL}. }
#' \item { Huffington Post: \href{http://elections.huffingtonpost.com/pollster}{Pollster} }
#'}
"polls08"
