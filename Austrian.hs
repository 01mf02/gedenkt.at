module Austrian where

import Data.Time.Format (TimeLocale (..))

austrianTimeLocale :: TimeLocale
austrianTimeLocale = TimeLocale {
  wDays = [ ("Sonntag"   , "So")
          , ("Montag"    , "Mo")
          , ("Dienstag"  , "Di")
          , ("Mittwoch"  , "Mi")
          , ("Donnerstag", "Do")
          , ("Freitag"   , "Fr")
          , ("Samstag"   , "Sa")
          ],

  months = [ ("Jänner"   , "Jän")
           , ("Feber"    , "Feb")
           , ("März"     , "Mär")
           , ("April"    , "Apr")
           , ("Mai"      , "Mai")
           , ("Juni"     , "Jun")
           , ("Juli"     , "Jul")
           , ("August"   , "Aug")
           , ("September", "Sep")
           , ("Oktober"  , "Okt")
           , ("November" , "Nov")
           , ("Dezember" , "Dez")
           ],

{-
  intervals = [ ("Jahr"  , "Jahre")
              , ("Monat" , "Monate")
              , ("Tag"   , "Tage")
              , ("Stunde", "Stunden")
              , ("min"   , "mins")
              , ("sec"   , "secs")
              , ("usec"  , "usecs")
              ],
-}

  amPm = ("AM", "PM"),
  dateTimeFmt = "%a %b %e %H:%M:%S %Z %Y",
  dateFmt = "%d.%m.%y",
  timeFmt = "%H:%M:%S",
  time12Fmt = "%I:%M:%S %p",
  knownTimeZones = []
}

