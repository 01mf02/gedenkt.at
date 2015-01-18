--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Austrian (austrianTimeLocale)
import           Data.Monoid ((<>))
import           System.FilePath (takeBaseName)
import           Hakyll
--------------------------------------------------------------------------------

allPosts :: [Pattern]
allPosts = ["blog/*", "musica/*", "erasmus/*"]

patternAny :: [Pattern] -> Pattern
patternAny = foldl1 (.||.)

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
      markdownCompiler $ postsCtx $ take 3 posts

  match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------

removeDate :: Routes
removeDate = gsubRoute "/[0-9]{4}-[0-9]{2}-[0-9]{2}-" (const "/")


mediaField :: Context String
mediaField = 
  field "media" (return . mediaPath . toFilePath . itemIdentifier)
  where mediaPath p = "/media/" ++ takeBaseName p

postCtx :: Context String
postCtx =
  dateFieldWith austrianTimeLocale "date" "%d. %B %Y" <>
  mediaField <>
  defaultContext

postsCtx :: [Item String] -> Context String
postsCtx posts =
  listField "posts" postCtx (return posts) <>
  defaultContext


postCompiler :: Compiler (Item String)
postCompiler =
  getResourceBody
    >>= applyAsTemplate postCtx
    >>= return . renderPandoc
    >>= loadAndApplyTemplate "templates/post.html"    postCtx
    >>= loadAndApplyTemplate "templates/default.html" postCtx
    >>= relativizeUrls

postListCompiler :: Pattern -> Compiler (Item String)
postListCompiler ptrn = do
  posts <- recentFirst =<< loadAll ptrn
  markdownCompiler $ postsCtx posts

markdownCompiler :: Context String -> Compiler (Item String)
markdownCompiler ctx =
  getResourceBody
    >>= applyAsTemplate ctx
    >>= return . renderPandoc
    >>= loadAndApplyTemplate "templates/default.html" ctx
    >>= relativizeUrls
