RGB_Edit( slider, type, hud, rgb )
{
    vec3 = (0,0,0);
    for(e=0;e<self.menu[ type ][ hud ].size+1;e++)
    {
        if(!IsDefined( self.menu[ type ][ hud ][self.menu[ type ][ hud ].size-e] ))
            continue;
        R = self.menu[ type ][ hud ][self.menu[ type ][ hud ].size-e].color[0];
        G = self.menu[ type ][ hud ][self.menu[ type ][ hud ].size-e].color[1];
        B = self.menu[ type ][ hud ][self.menu[ type ][ hud ].size-e].color[2];
        
        if( rgb == "R" )        vec3 = ((slider / 255), G, B);
        if( rgb == "G" )        vec3 = (R, (slider / 255), B);
        if( rgb == "B" )        vec3 = (R, G, (slider / 255));
            
        self.menu[ type ][ hud ][self.menu[ type ][ hud ].size-e].color = vec3;
    }
    self.menuCust[ hud ] = vec3;
    self scrollingSystem();
}

menuPosEditor()
{
    self thread refreshMenu();
    wait .28;
    
    posEditor = [];
    posEditor[0] = self createRectangle("TOP", "CENTER", self.presets["X"] - 185, self.presets["Y"] - 175, 120, 183, self.menuCust["OPT_BG"], "white", 2, .5);
    posEditor[1] = self createText("default", 1.4, "CENTER", "CENTER", self.presets["X"] - 185, self.presets["Y"] - 160, 3, 1, "POSITION EDITOR", self.menuCust["TITLE"]);   
    posEditor[2] = self createText("default", 1.2, "CENTER", "CENTER", self.presets["X"] - 185, self.presets["Y"] - 115, 3, 1, "^0* ^7USER CONTROLS^0 *^7", self.menuCust["TITLE"]);  
    posEditor[3] = self createText("default", 1, "CENTER", "CENTER", self.presets["X"] - 185, self.presets["Y"] - 100, 3, 1, "UP - [{+attack}]    DOWN - [{+speed_throw}]", self.menuCust["TITLE"]);  
    posEditor[4] = self createText("default", 1, "CENTER", "CENTER", self.presets["X"] - 185, self.presets["Y"] - 85, 3, 1, "LEFT - [{+actionslot 3}]    RIGHT - [{+actionslot 4}]", self.menuCust["TITLE"]);  
    posEditor[5] = self createText("default", 1, "CENTER", "CENTER", self.presets["X"] - 185, self.presets["Y"] - 60, 3, 1, "CONFIRM POSITION - [{+reload}]", self.menuCust["TITLE"]);  
    posEditor[6] = self createText("default", 0.7, "CENTER", "CENTER", self.presets["X"] - 185, self.presets["Y"] - 15, 3, 1, "*THIS MENU IS MULTI TABBED*", self.menuCust["TITLE"]);  
    posEditor[7] = self createText("default", 0.7, "CENTER", "CENTER", self.presets["X"] - 185, self.presets["Y"] - 5, 3, 1, "*BE CAUTIOUS WHEN CHOOSING POSITION*", self.menuCust["TITLE"]);  
     
    xPos = self.presets["X"]; yPos = self.presets["Y"];
    while( !self MeleeButtonPressed() )
    {
        if( self attackButtonPressed() && yPos <= 225 )
        {
            yPos += 10;
            foreach( hud in posEditor )
                hud.y += 10;
            wait .1;       
        }
        else if( self adsButtonPressed() && yPos >= -49 )
        {
            yPos -= 10;
            foreach( hud in posEditor )
                hud.y -= 10;
            wait .1;    
        }
        else if( self.actionSlotsPressed[ "dpad_right" ] && xPos <= 543 )
        {
            xPos += 10;
            foreach( hud in posEditor )
                hud.x += 10;
            wait .1;      
        }
        else if( self.actionSlotsPressed[ "dpad_left" ] && xPos >= -170 )
        {
            xPos -= 10;
            foreach( hud in posEditor )
                hud.x -= 10;
            wait .1;      
        }
        else if( self UseButtonPressed() )
            break;
        wait .05;
    }
    self.presets["X"] = xPos;
    self.presets["Y"] = yPos;
    self destroyAll( posEditor );
    self notify( "reopen_menu" );
}