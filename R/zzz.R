datacache <- new.env(hash=TRUE, parent=emptyenv())

org.RAGIS1.0.eg <- function() showQCData("org.RAGIS1.0.eg", datacache)
org.RAGIS1.0.eg_dbconn <- function() dbconn(datacache)
org.RAGIS1.0.eg_dbfile <- function() dbfile(datacache)
org.RAGIS1.0.eg_dbschema <- function(file="", show.indices=FALSE) dbschema(datacache, file=file, show.indices=show.indices)
org.RAGIS1.0.eg_dbInfo <- function() dbInfo(datacache)

org.RAGIS1.0.egORGANISM <- "rice AGIS1.0"

.onLoad <- function(libname, pkgname)
{
    ## Connect to the SQLite DB
    dbfile <- system.file("extdata", "org.RAGIS1.0.eg.sqlite", package=pkgname, lib.loc=libname)
    assign("dbfile", dbfile, envir=datacache)
    dbconn <- dbFileConnect(dbfile)
    assign("dbconn", dbconn, envir=datacache)

    ## Create the OrgDb object
    sPkgname <- sub(".db$","",pkgname)
    db <- loadDb(system.file("extdata", paste(sPkgname,
      ".sqlite",sep=""), package=pkgname, lib.loc=libname),
                   packageName=pkgname)    
    dbNewname <- AnnotationDbi:::dbObjectName(pkgname,"OrgDb")
    ns <- asNamespace(pkgname)
    assign(dbNewname, db, envir=ns)
    namespaceExport(ns, dbNewname)
        
    packageStartupMessage(AnnotationDbi:::annoStartupMessages("org.RAGIS1.0.eg.db"))
}

.onUnload <- function(libpath)
{
    dbFileDisconnect(org.RAGIS1.0.eg_dbconn())
}

