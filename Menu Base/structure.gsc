initializeSetup( access, player )
{
    if( level.status[ access ] == player.access && !player isHost() && isDefined(player.access) )
        return self iprintln(player getName() + " is already this access level.");
    if( isDefined(player.access) && player.access == level.status[ 4 ] )
        return self iprintln("You can not edit players with access level Host.");
            
    player notify("end_menu");
    player.access = level.status[ access ];
    
    if( player isMenuOpen() )
        player menuClose();

    player.menu = [];
    player.previousMenu = [];
    player.menu["isOpen"] = false;
    player.menu["isLocked"] = false;

    if( !isDefined(player.menu["current"]) )
         player.menu["current"] = "main";
    if( !IsDefined( player.hud_amount ) )
        player.hud_amount = 0;
         
    player thread actionSlotButtonPressed("dpad_left");
    player thread actionSlotButtonPressed("dpad_right");
    player thread actionSlotButtonPressed("dpad_down");
    player thread actionSlotButtonPressed("dpad_up");
    player thread actionSlotButtonPressed("jump");
    player thread actionSlotButtonPressed("stance");
    
    player load_presets();         
    player menuOptions();
    player thread menuMonitor();
    player thread customNoticon( "Multi Submenu Menu Base:", "Developed By Extinct" );
}

newMenu( menu )
{
    if(!IsDefined( self.previousMenu ))
        self.previousMenu = [];
    if(isDefined( menu ))
    {
        self drawMenu();
        self drawText();
    }
    
    if(!isDefined( menu ))
    {
        menu = self.previousMenu[ self.previousMenu.size -1 ];
        self.previousMenu[ self.previousMenu.size -1 ] = undefined;
        
        self.menu["UI"]["OPT_BG"][self.menu["UI"]["OPT_BG"].size-1] thread hudFadeDestroy(0, .14);
        self.menu["UI"]["OPT_BG"][self.menu["UI"]["OPT_BG"].size-1] = undefined;
        
        self.menu["UI"]["SCROLL"][self.menu["UI"]["SCROLL"].size-1] thread hudFadeDestroy(0, .14);
        self.menu["UI"]["SCROLL"][self.menu["UI"]["SCROLL"].size-1] = undefined;
        
        self.menu["OPT"]["TITLE"][self.menu["OPT"]["TITLE"].size-1] thread hudFadeDestroy(0, .14);
        self.menu["OPT"]["TITLE"][self.menu["OPT"]["TITLE"].size-1] = undefined;
        
        self.menu["OPT"]["MENU"][self.menu["OPT"]["MENU"].size-1] thread hudFadeDestroy(0, .14);
        self.menu["OPT"]["MENU"][self.menu["OPT"]["MENU"].size-1] = undefined;
    }
    else 
        self.previousMenu[ self.previousMenu.size ] = self getCurrentMenu();
        
    self setCurrentMenu( menu );
    self menuOptions();
    self refreshTitle();
    self resizeMenu();  
    wait .15; 
    self updateScrollbar();
}

addMenu( menu, title )
{
    self.storeMenu = menu;
    if(self getCurrentMenu() != menu)
        return;
        
    self.eMenu = [];
    self.menuTitle = title;
    if(!isDefined(self.menu[ menu + "_cursor"]))
        self.menu[ menu + "_cursor"] = 0;
}

addOpt( opt, func, p1, p2, p3, p4, p5 )
{
    if(self getCurrentMenu() != self.storeMenu)
        return;
    option      = spawnStruct();
    option.opt  = opt;
    option.func = func;
    option.p1   = p1;
    option.p2   = p2;
    option.p3   = p3;
    option.p4   = p4;
    option.p5   = p5;
    self.eMenu[self.eMenu.size] = option;
}

addSliderValue( opt, val, min, max, mult, func, p1, p2, p3, p4, p5 )
{
    if(self getCurrentMenu() != self.storeMenu)
        return;
    option      = spawnStruct();
    option.opt  = opt;
    option.val = val;
    option.min  = min;
    option.max  = max;
    option.mult  = mult;
    option.func = func;
    option.p1   = p1;
    option.p2   = p2;
    option.p3   = p3;
    option.p4   = p4;
    option.p5   = p5;
    self.eMenu[self.eMenu.size] = option;
}

addSliderString( opt, ID_list, RL_list, func, p1, p2, p3, p4, p5 )
{
    if(self getCurrentMenu() != self.storeMenu)
        return;
    option      = spawnStruct();
    
    if(!IsDefined( RL_list ))
        RL_list        = ID_list;
    option.ID_list = strTok(ID_list, ";");
    option.RL_list = strTok(RL_list, ";");
    
    option.opt  = opt;
    option.func = func;
    option.p1   = p1;
    option.p2   = p2;
    option.p3   = p3;
    option.p4   = p4;
    option.p5   = p5;
    self.eMenu[self.eMenu.size] = option;
}

setCurrentMenu( menu )
{
    self.menu["current"] = menu;
}

getCurrentMenu()
{
    return self.menu["current"];
}

getCursor()
{
    return self.menu[ self getCurrentMenu() + "_cursor" ];
}

isMenuOpen()
{
    if( !isDefined(self.menu["isOpen"]) || !self.menu["isOpen"] )
        return false;
    return true;
}

hasMenu()
{
    if( IsDefined( self.access ) && self.access != "None" )
        return true;
    return false;    
}
