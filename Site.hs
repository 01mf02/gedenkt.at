--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.List (isSuffixOf)
import           Data.Monoid ((<>))
import qualified Data.Set as S
import           System.FilePath ((</>), takeBaseName, takeDirectory)

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
    route $ removeDate `composeRoutes` cleanRoute
    compile postCompiler

  match "erasmus.md" $ do
    route   $ cleanRoute
    compile $ namePatternCompiler erasmusLists

  match "musica.md" $ do
    route   $ cleanRoute
    compile $ patternCompiler "musica/*"

  match "blog.md" $ do
    route   $ cleanRoute
    compile $ patternCompiler "blog/*"

  match "tourdeurope.md" $ do
    route   $ cleanRoute
    compile $ markdownCompiler (mediaField <> defaultContext)

  match "index.md" $ do
    route   $ setExtension "html"
    compile $ do
      posts <- recentFirst =<< loadAll (patternAny allPosts)
      nameItemsCompiler [("posts", take 3 posts)]

  match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
-- Patterns

allPosts :: [Pattern]
allPosts = ["blog/*", "musica/*", "erasmus/**"]

patternAny :: [Pattern] -> Pattern
patternAny = foldl1 (.||.)

erasmusLists :: [(String, Pattern)]
erasmusLists =
  [ ("bordeaux", "erasmus/bordeaux/*")
  , ("praha"   , "erasmus/praha/*")
  ]


--------------------------------------------------------------------------------
-- Routes

removeDate :: Routes
removeDate = gsubRoute "/[0-9]{4}-[0-9]{2}-[0-9]{2}-" (const "/")

cleanRoute :: Routes
cleanRoute = customRoute createIndexRoute where
  createIndexRoute ident =
    let p = toFilePath ident
    in takeDirectory p </> takeBaseName p </> "index.html"


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

postListCtx :: String -> [Item String] -> Context String
postListCtx name = listField name postCtx . return


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

renderPandocMath :: Item String -> Compiler (Item String)
renderPandocMath = renderPandocWith defaultHakyllReaderOptions writerOptions


--------------------------------------------------------------------------------
-- Compilers for different kinds of documents

postCompiler :: Compiler (Item String)
postCompiler =
  getResourceBody
    >>= renderPandocMath
    >>= applyAsTemplate postCtx
    >>= loadAndApplyTemplate "templates/post.html"    postCtx
    >>= loadAndApplyTemplate "templates/default.html" postCtx
    >>= relativizeUrls
    >>= cleanIndexUrls

cleanIndexUrls :: Item String -> Compiler (Item String)
cleanIndexUrls = return . fmap (withUrls cleanIndex)

cleanIndexHtmls :: Item String -> Compiler (Item String)
cleanIndexHtmls = return . fmap (replaceAll pattern replacement)
  where
    pattern = "/index.html"
    replacement = const "/"

cleanIndex :: String -> String
cleanIndex url
    | idx `isSuffixOf` url = take (length url - length idx) url
    | otherwise            = url
  where idx = "index.html"

nameItemsCompiler :: [(String, [Item String])] -> Compiler (Item String)
nameItemsCompiler postLists = markdownCompiler $ defaultContext <> mconcat ctxs
  where ctxs = map (uncurry postListCtx) postLists

namePatternCompiler :: [(String, Pattern)] -> Compiler (Item String)
namePatternCompiler lists =
  mapM (uncurry loadNamePattern) lists >>= nameItemsCompiler

loadNamePattern :: String -> Pattern -> Compiler (String, [Item String])
loadNamePattern name ptrn = loadAll ptrn >>= recentFirst >>= return . (,) name

patternCompiler :: Pattern -> Compiler (Item String)
patternCompiler ptrn = namePatternCompiler [("posts", ptrn)]

markdownCompiler :: Context String -> Compiler (Item String)
markdownCompiler ctx =
  getResourceBody
    >>= applyAsTemplate ctx
    >>= renderPandoc
    >>= loadAndApplyTemplate "templates/default.html" ctx
    >>= relativizeUrls
    >>= cleanIndexUrls
