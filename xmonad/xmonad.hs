import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Actions.GridSelect --(myGSConfig, goToSelected)
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
--import XMonad.Actions.Volume
--import Data.Map (fromList)
--import Data.Monoid (mappend)

myGSConfig = defaultGSConfig { gs_cellwidth = 160, gs_font = "xft:Inconsolata:size=8:antialias=true" }

myManageHook = composeAll
    [ className =? "Gimp"      --> doFloat
    , className =? "Vncviewer" --> doFloat
    , className =? "com-mathworks-util-PostVMInit" --> doFloat
    , className =? "Gorilla" --> doFloat
    , className =? "Gorilla.tcl" --> doFloat
    , className =? "Toplevel" --> doFloat
    , className =? "__main__.py" --> doFloat
    , className =? "Xmessage" --> doFloat
    , className =? " " --> doFloat
    , className =? "XEyes" --> doFloat
    , className =? "XCalc" --> doFloat
    , className =? "Shutter" --> doFloat
    , className =? "XTerm" --> doFloat
    , className =? "URxvt" --> doFloat
    , isFullscreen --> doFullFloat
    ]

myWorkspaces    = ["1", "2" ,"3", "4", "5", "6", "7", "8", "9"]
--myWorkspaces    = ["α", "β" ,"γ", "δ", "ε", "ζ", "η", "θ", "ι"]
--myWorkspaces    = ["Α", "Β" ,"Γ", "Δ", "Ε", "Ζ", "Η", "Θ", "Ι"]

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/nmoran/.xmobarrc"
    xmonad $ ewmh defaultConfig
        { startupHook = setWMName "LG3D"
         , manageHook = manageDocks <+> manageHook defaultConfig <+> myManageHook 
         , handleEventHook = handleEventHook defaultConfig <+> fullscreenEventHook
         , layoutHook = smartBorders (avoidStruts  $  layoutHook defaultConfig)
         , logHook = dynamicLogWithPP xmobarPP
                         { ppOutput = hPutStrLn xmproc
                         , ppTitle = xmobarColor "white" "" . shorten 50
                         }
         , modMask = mod4Mask
         , workspaces         = myWorkspaces
         , normalBorderColor  = "#111"
--       , focusedBorderColor = "cadetblue3"
         , focusedBorderColor = "red"
--	     , terminal = "urxvt"
	       , terminal = "gnome-terminal"
         , borderWidth = 3
--       , keys = xmonad defaultConfig 'mapped'
--            \c -> fromList [
--                ((0, xK_F2), lowerVolume 4 >> return ()),
--                ((0, xK_F3), raiseVolume 4 >> return ())
--                ]
        } `additionalKeys`
            [ ((mod4Mask , xK_s), goToSelected myGSConfig)
            ,((mod4Mask , xK_x), spawn "slock")
            , ((mod4Mask , xK_f), spawn "thunar")
            , ((mod4Mask , xK_n), spawn "urxvt -e /home/nmoran/local/bin/new_notebook.sh")
            , ((mod4Mask , xK_h), spawn "urxvt -e htop")
            , ((mod4Mask , xK_i), spawn "urxvt -e ipython --pylab")
            , ((mod4Mask , xK_v), spawn "/home/nmoran/local/bin/screenshot.sh &")
            , ((mod4Mask , xK_d), spawn "dmenu_run -fn '-*-helvetica-bold-*-normal-*-*-180-*-*-*-*-*-*' -o 70 ")
        --   , ((mod4Mask , xK_d), spawn "dmenu_run -fn '-*-*-bold-*-normal-*-*-40-*-*-*-*-*-*' ")
        --   , ((mod4Mask , xK_d), spawn "dmenu_run -f")
            ]
