quick_menu_options()
{
    self add_quick_menu( "quick", "Quick Menu" );
    self add_quick_opt( "Godmode", ::godmode, self.godmode );
    self add_quick_opt( "No-clip Bind", ::noClipExt, self.noclipBind );
    self add_quick_opt( "Infinite Ammo", ::infiniteAmmo, self.infAmmo, "Reload" );
    self add_quick_opt( "Faster Movements", ::set_movement_speed, self.movement_speed, 1.5 );
}

open_quick_menu()
{
    self.in_quick_menu = true;
    if(!IsDefined( self.current_quick_menu ))
        self.current_quick_menu = "quick";
    
    self quick_menu_options();
    self draw_quick_menu();
    
    self thread monitor_quick_menu();
}

draw_quick_menu()
{
    if(!IsDefined(self.q_menu))
        self.q_menu = [];
    else self destroyAll( self.q_menu );
        
    size = self.eMenu_quick.size;
    x    = self.presets["X"] - 245; 
    y    = self.presets["Y"] - 175 + ( 16 * (size + 1) ); //CLAMPS TO TOP
    
    time = .04 * (size + 1);
    
    //HUDS 
    self.q_menu[0] = self createRectangle( "TOP", "CENTER", 0 + x, -2 + y, 2, 0, (0,0,0), "white", 4, 1 ); //line left
    self.q_menu[0] ScaleOverTime( time, 2, 31 * (size + 1) );
    self.q_menu[0] hudMoveY( y + ( 16 * (size + 1) ) * -1, time);
    wait .2;
    
    self.q_menu[1] = self createRectangle( "TOP", "CENTER", 3 + x, 0 + y, 2, 30, (0,0,0), "white", 4, .6 ); //line left
    self.q_menu[1] hudMoveY( y + ( 16 * (size + 1) ) * -1, time);
    wait time;
    self.q_menu[1] ScaleOverTime( time, 2, 31 * (size + 1) );
    
    //TITLE BOX
    text  = self.q_menuTitle;
    width = int((getWidth(text) / 3.5 ) + text.size + 5);
    self.q_menu[2] = self createRectangle("TOPLEFT", "CENTER", 2 + x, y + ( 16 * (size + 1) ) * -1, 2, 0, (0,0,0), "white", 4, .8 );
    self.q_menu[2] thread _scaleovertime( time, width );
    wait time / 2;
    
    for(e=0;e<self.eMenu_quick.size;e++)
    {
        text  = self.eMenu_quick[e].opt;
        width = int((getWidth(text) / 3.5 ) + text.size + 5);
        self.q_menu[3 + e] = self createRectangle("TOPLEFT", "CENTER", 2 + x, y + ( 16 * (size + 1) ) * -1 + ((e+1) * 31), 2, 0, (0,0,0), "white", 4, .6 );
        self.q_menu[3 + e] thread _scaleovertime( time, width );
        wait time / 2;
    }
    self.q_menu[1] thread hudFadeDestroy( 0, time / 2 );
    wait time;
     
    //STRINGS
    self.q_menu["title"] = self createText( "default", 1, "LEFT", "CENTER", 5 + x, self.q_menu[2].y + 14, 4, 0, self.q_menuTitle, (1,1,1)); 
    self.q_menu["title"] thread hudFade(1, .1); 
    
    for(e=0;e<self.eMenu_quick.size;e++)
    {
        self.q_menu["opt_" + e] = self createText( "default", 1, "LEFT", "CENTER", 5 + x, self.q_menu[3 + e].y + 14, 4, 0, self.eMenu_quick[e].opt, get_colour( e )); 
        self.q_menu["opt_" + e] thread hudFade(1, .1); 
    }
    self.q_menu["opt_" + self get_quick_curs()].color = get_colour( self get_quick_curs() );
    self.q_menu["opt_scroll" ] = self createRectangle("TOP", "CENTER", 0 + x, self.q_menu["opt_" + self get_quick_curs()].y - 14, 2, 30, (1,0,.89), "white", 5, 1 );
}

_scaleovertime( time, width )
{
    self ScaleOverTime( time, 2, 30 );
    wait time / 2;
    self ScaleOverTime( time, width, 30 );
}

close_quick_menu()
{
    self destroyAll( self.q_menu );  
    self.in_quick_menu = undefined;
}

monitor_quick_menu()
{
    while( isDefined( self.in_quick_menu ) )
    {
        if( self UseButtonPressed() )
        {
            if( self.eMenu_quick[self get_quick_curs()].func == ::new_quick_menu )
                self new_quick_menu( self.eMenu_quick[self get_quick_curs()].p1 );
            else 
                self thread [[ self.eMenu_quick[self get_quick_curs()].func ]]( self.eMenu_quick[self get_quick_curs()].p1, self.eMenu_quick[self get_quick_curs()].p2 );
            
            self quick_menu_options();        
            self.q_menu["opt_" + self get_quick_curs()].color = get_colour( self get_quick_curs() );
            wait .2;
        }
        else if( self AttackButtonPressed() || self AdsButtonPressed() )
        {
            old_curs = self get_quick_curs();
            self.menu[ self.current_quick_menu + "_cursor" ] += self attackButtonPressed();
            self.menu[ self.current_quick_menu + "_cursor" ] -= self adsButtonPressed();
            
            self.q_menu["opt_" + old_curs].color = get_colour( old_curs );
            
            if(self get_quick_curs() < 0)
                self.menu[ self.current_quick_menu + "_cursor" ] = self.eMenu_quick.size-1;
            else if(self get_quick_curs() >= self.eMenu_quick.size)
                self.menu[ self.current_quick_menu + "_cursor" ] = 0;
            
            self.q_menu["opt_" + self get_quick_curs()].color = get_colour( self get_quick_curs() );
            self.q_menu["opt_scroll" ].y = self.q_menu["opt_" + self get_quick_curs()].y - 14;
            wait .2;
        }
        else if( self MeleeButtonPressed() )
        {
            IPrintLn( "closed" );
            if( self.current_quick_menu == "quick" )
                self close_quick_menu();
            else    
                self new_quick_menu();
        }
        wait .05;
    }
}
    
new_quick_menu( menu )
{
    if(!IsDefined( self.previousMenu_q ))
        self.previousMenu_q = [];
        
    if(!isDefined( menu ))
    {
        menu = self.previousMenu_q[ self.previousMenu_q.size -1 ];
        self.previousMenu_q[ self.previousMenu_q.size -1 ] = undefined;
    }
    else 
        self.previousMenu_q[ self.previousMenu_q.size ] = self.current_quick_menu;
    
    self.current_quick_menu = menu;
    self quick_menu_options();
    self draw_quick_menu();
    wait .15; 
    //self updateScrollbar();
}

add_quick_menu( menu, title )
{
    self.storeMenu_q = menu;
    if(self.current_quick_menu != menu)
        return;
        
    self.eMenu_quick = [];
    self.q_menuTitle = title;
    if(!isDefined(self.menu[ menu + "_cursor"]))
        self.menu[ menu + "_cursor"] = 0;
}

add_quick_opt( opt, func, col, p1, p2 )
{
    if(self.current_quick_menu != self.storeMenu_q)
        return;
    option        = spawnStruct();
    option.opt    = opt;
    option.func = func;
    option.col = col;
    option.p1   = p1;
    option.p2   = p2;
    self.eMenu_quick[self.eMenu_quick.size] = option;
}

getWidth(str) 
{
    return RPC(0x40F710, str, 0x7FFFFFFF, regFont("fonts/normalFont"));
}

regFont(font)
{
    return RPC(0x40F6D0, font, 0);
}

get_quick_curs()
{
    return self.menu[ self.current_quick_menu + "_cursor" ];
}

get_colour( curs )
{
    if( self get_quick_curs() == curs && !isDefined( self.eMenu_quick[ curs ].col ) )
        return (1,0,.89);
    if( isDefined( self.eMenu_quick[curs].col ))
        return (0,1,0);
    return (1,1,1);    
}
