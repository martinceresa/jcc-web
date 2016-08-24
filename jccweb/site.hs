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

    {-
       match "data/*" $ do
           route $ setExtension "html"
           compile $ pandocCompiler
               >>= loadAndApplyTemplate "templates/charla.html"    postCtx
               >>= loadAndApplyTemplate "templates/default.html" postCtx
               >>= relativizeUrls
    -}

    match "index.html" $ do
        route idRoute
        compile $ do
            charlas <- recentFirst =<< loadAll "charlas/*"
            let indexCtx =
                    listField "charlas" postCtx (return charlas) `mappend`
                    constField "title" "Home"                `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext
