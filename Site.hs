--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid ((<>))
import qualified Data.Set as S
import           System.FilePath (takeBaseName)

import           Hakyll
import           Text.Pandoc.Options

import           Austrian (austrianTimeLocale)
--------------------------------------------------------------------------------


main :: IO ()
main = hakyll $ do

  match "media/**" $ do
    route   idRoute
    compile copyFileCompiler

  match "css/*" $ do
    route   idRoute
    compile compressCssCompiler

  match (patternAny allPosts) $ do
    route $ removeDate `composeRoutes` setExtension "html"
    compile postCompiler

  match "erasmus.md" $ do
    route   $ setExtension "html"
    compile $ postListCompiler "erasmus/*"

  match "musica.md" $ do
    route   $ setExtension "html"
    compile $ postListCompiler "musica/*"

  match "blog.md" $ do
    route   $ setExtension "html"
    compile $ postListCompiler "blog/*"

  match "tourdeurope.md" $ do
    route   $ setExtension "html"
    compile $ markdownCompiler (mediaField <> defaultContext)

  match "index.md" $ do
    route   $ setExtension "html"
    compile $ do
      posts <- recentFirst =<< loadAll (patternAny allPosts)
      markdownCompiler $ postListCtx $ take 3 posts

  match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
-- Patterns

allPosts :: [Pattern]
allPosts = ["blog/*", "musica/*", "erasmus/*"]

patternAny :: [Pattern] -> Pattern
patternAny = foldl1 (.||.)


--------------------------------------------------------------------------------
-- Routes

removeDate :: Routes
removeDate = gsubRoute "/[0-9]{4}-[0-9]{2}-[0-9]{2}-" (const "/")


--------------------------------------------------------------------------------
-- Fields and Contexts

mediaField :: Context a
mediaField = 
  field "media" (return . mediaPath . toFilePath . itemIdentifier)
  where mediaPath p = "/media/" ++ takeBaseName p

postCtx :: Context String
postCtx =
  dateFieldWith austrianTimeLocale "date" "%d. %B %Y" <>
  mediaField <>
  defaultContext

postListCtx :: [Item String] -> Context String
postListCtx posts =
  listField "posts" postCtx (return posts) <>
  defaultContext


--------------------------------------------------------------------------------
-- Math rendering in Pandoc

writerOptions :: WriterOptions
writerOptions = defaultHakyllWriterOptions {
  writerExtensions = newExtensions,
  writerHTMLMathMethod = MathJax ""
} where
    mathExtensions = [Ext_tex_math_double_backslash]
    defaultExtensions = writerExtensions defaultHakyllWriterOptions
    newExtensions = foldr S.insert defaultExtensions mathExtensions

renderPandocMath :: Item String -> Item String
renderPandocMath = renderPandocWith defaultHakyllReaderOptions writerOptions


--------------------------------------------------------------------------------
-- Compilers for different kinds of documents

postCompiler :: Compiler (Item String)
postCompiler =
  getResourceBody
    >>= return . renderPandocMath
    >>= applyAsTemplate postCtx
    >>= loadAndApplyTemplate "templates/post.html"    postCtx
    >>= loadAndApplyTemplate "templates/default.html" postCtx
    >>= relativizeUrls

postListCompiler :: Pattern -> Compiler (Item String)
postListCompiler ptrn = do
  posts <- recentFirst =<< loadAll ptrn
  markdownCompiler $ postListCtx posts

markdownCompiler :: Context String -> Compiler (Item String)
markdownCompiler ctx =
  getResourceBody
    >>= applyAsTemplate ctx
    >>= return . renderPandoc
    >>= loadAndApplyTemplate "templates/default.html" ctx
    >>= relativizeUrls
