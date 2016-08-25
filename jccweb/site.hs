--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll


--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "logos/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    {-
       match (fromList ["about.rst", "contact.markdown"]) $ do
           route   $ setExtension "html"
           compile $ pandocCompiler
               >>= loadAndApplyTemplate "templates/default.html" defaultContext
               >>= relativizeUrls
    -}

    match "data/*" $ do
     route $ setExtension "html"
     compile $ pandocCompiler
      >>= loadAndApplyTemplate "templates/charla.html" charlaCtx
      >>= loadAndApplyTemplate "templates/default.html" charlaCtx
      >>= relativizeUrls

    match "index.html" $ do
        route idRoute
        compile $
            do
                -- charlas <- recentFirst =<< loadAll (fromGlob "data/*")
                let indexCtx =
                        listField "charlas" charlaCtx (loadAll (fromRegex "data/*") :: Compiler [Item String]) `mappend`
                        constField "title" "Home"                `mappend`
                        charlaCtx

                getResourceBody
                    >>= applyAsTemplate indexCtx
                    >>= loadAndApplyTemplate "templates/default.html" indexCtx
                    >>= relativizeUrls

    match "templates/*" $ compile $
        templateCompiler

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

charlaCtx :: Context String
charlaCtx =
    field "id" (return . itemBody) `mappend`
    metadataField `mappend`
    defaultContext
