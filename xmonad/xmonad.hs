import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeInactive
import XMonad.Layout.Spiral
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
-- requires xmonad-extras-darcs which is currently broken
-- import XMonad.Actions.Volume
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import Graphics.X11.ExtraTypes.XF86

myTerminal = "urxvt"

myBorderWidth = 0

myMask = mod3Mask     -- Rebind Mod to the changed capslock mask

colorFormatter = xmobarColor

myPurple = "#a45bad"
myWhite = "#e3dedd"
myGreen = "#2d9574"

myLoghook h = myFadeHook >> dynamicLogWithPP xmobarPP
            { ppOutput     = hPutStrLn h
            , ppCurrent    = colorFormatter myWhite myPurple . pad
            , ppTitle      = colorFormatter myGreen "" . shorten 50
            }

myLayouts = tiled ||| Mirror tiled ||| Full ||| spiral goldenRatio
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled      = smartSpacing 8 $ Tall nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster    = 1

    goldenRatio = toRational (2/(1+sqrt(5)::Double))

    -- Default proportion of screen occupied by master pane
    ratio      = 1/2

    -- Percent of screen to increment by when resizing panes
    delta      = 2/100

myFadeHook = fadeInactiveLogHook fadeAmount
     where fadeAmount = 0.9

main = do
    xmproc <- spawnPipe "xmobar"

    xmonad $ defaultConfig
        { manageHook = manageDocks <+> manageHook defaultConfig
        , terminal = myTerminal
        , layoutHook = avoidStruts $ smartBorders myLayouts
        , logHook = myLoghook xmproc
        , modMask = myMask
        , handleEventHook = fullscreenEventHook
        , borderWidth = myBorderWidth
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock; sleep 0.5 && xset dpms force off")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        , ((0, xF86XK_MonBrightnessUp), spawn "xbacklight -inc 10")
        , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -dec 10")
        -- , ((0, xF86XK_AudioLowerVolume), lowerVolume 5 >> return ())
        -- , ((0, xF86XK_AudioRaiseVolume), raiseVolume 5 >> return ())
        ]
