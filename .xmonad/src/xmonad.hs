{-# LANGUAGE OverloadedStrings #-}

import Data.Default
import Data.Ratio
import XMonad
import XMonad.Actions.NoBorders
import XMonad.Actions.UpdatePointer
import XMonad.Actions.Warp
import XMonad.Config.Xfce
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.Accordion
import XMonad.Layout.Grid
import XMonad.Layout.LayoutHints
import XMonad.Layout.Magnifier
import XMonad.Layout.NoBorders
import XMonad.Layout.ToggleLayouts
import XMonad.Util.EZConfig

import qualified Codec.Binary.UTF8.String as UTF8
import qualified DBus as D
import qualified DBus.Client as D

main :: IO ()
main = do
  dbus <- D.connectSession
  getWellKnownName dbus
  xmonad $ docks $ xfceConfig
    { logHook =
        do updatePointer (0.5, 0.5) (0, 0)
           dynamicLogWithPP (prettyPrinter dbus)
           fadeInactiveLogHook 0.8
           ewmhDesktopsLogHook
    , startupHook =
        do setWMName "LG3D"
           ewmhDesktopsStartup
           docksStartupHook
    , manageHook = myManageHook
    , layoutHook = myLayoutHook
    , handleEventHook = ewmhDesktopsEventHook <+> fullscreenEventHook
    , terminal = "alacritty -e nvim term://zsh"
    , borderWidth = 0
    , modMask = mod4Mask
    }

myManageHook = composeAll
  [ className =? "Firefox"   --> doShift "1"
  , className =? "Skype"     --> doShift "7"
  , className =? "Evolution" --> doShift "9"
  , className =? "Peek"      --> doFloat
  , manageHook xfceConfig
  , manageDocks
  ]

myLayoutHook = avoidStruts (tiled ||| Mirror tiled ||| Full)
  where
    tiled = magnifiercz' 1.33 $ layoutHintsToCenter $ Tall 1 (3 / 100) (1 / 2)

prettyPrinter :: D.Client -> PP
prettyPrinter dbus = def
  { ppOutput = dbusOutput dbus
  , ppTitle = pangoSanitize
  , ppCurrent = pangoColor "green" . wrap "[" "] " . pangoSanitize
  , ppVisible = pangoColor "yellow" . wrap "(" ") " . pangoSanitize
  , ppHidden = const ""
  , ppUrgent = pangoColor "red"
  , ppLayout = const ""
  , ppSep = " "
  }

getWellKnownName :: D.Client -> IO ()
getWellKnownName dbus = do
  D.requestName dbus (D.busName_ "org.xmonad.Log")
    [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
  return ()

dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
  let signal = (D.signal "/org/xmonad/Log" "org.xmonad.Log" "Update") {
    D.signalBody = [D.toVariant ("<b> " ++ UTF8.decodeString str ++ "</b>")]
  }
  D.emit dbus signal

pangoColor :: String -> String -> String
pangoColor fg = wrap left right
  where
    left = "<span foreground=\"" ++ fg ++ "\">"
    right = "</span>"

pangoSanitize :: String -> String
pangoSanitize = foldr sanitize ""
  where
    sanitize '>' xs = "&gt;" ++ xs
    sanitize '<' xs = "&lt;" ++ xs
    sanitize '\"' xs = "&quot;" ++ xs
    sanitize '&' xs = "&amp;" ++ xs
    sanitize x xs = x : xs
