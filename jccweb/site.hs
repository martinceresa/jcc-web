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

    match "js/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "logos/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "data/*" $ do
     route $ setExtension "html"
     compile $ pandocCompiler
      >>= loadAndApplyTemplate "templates/charla.html" charlaCtx
      >>= relativizeUrls

    match "index.html" $ do
        route idRoute
        compile $
            do
                let indexCtx =
                        listField "charlas" charlaCtx (loadAll (fromRegex "data/*") :: Compiler [Item String]) `mappend`
                        constField "title" "Home"                `mappend`
                        defaultContext

                getResourceBody
                    >>= applyAsTemplate indexCtx
                    >>= loadAndApplyTemplate "templates/default.html" indexCtx
                    >>= relativizeUrls

    match "templates/*" $ compile $
        templateCompiler

--------------------------------------------------------------------------------
charlaCtx :: Context String
charlaCtx =
    field "id" (return . itemBody) `mappend`
    metadataField `mappend` -- Este no me gusta, pero lo emprolijo dsp
    defaultContext
