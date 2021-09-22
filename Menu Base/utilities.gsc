createText(font, fontScale, align, relative, x, y, sort, alpha, text, color, isLevel)
{
    if(isDefined(isLevel))
        textElem = level createServerFontString(font, fontScale);
    else 
        textElem = self createFontString(font, fontScale);
    
    textElem setPoint(align, relative, x, y);
    textElem.hideWhenInMenu = true;
    
    textElem.archived = false;
    if( self.hud_amount >= 22 ) 
        textElem.archived = true;
    
    textElem.sort           = sort;
    textElem.alpha          = alpha;
    textElem.color          = color;
    self addToStringArray(text);
    textElem thread watchForOverFlow(text);
    
    if(!IsDefined( isLevel ))
        self.hud_amount++;
    return textElem;
}

createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha, server)
{
    if(isDefined(server))
        boxElem = newHudElem();
    else
        boxElem = newClientHudElem(self);

    boxElem.elemType = "icon";
    boxElem.color = color;
    if(!level.splitScreen)
    {
        boxElem.x = -2;
        boxElem.y = -2;
    }
    boxElem.hideWhenInMenu = true;
    
    boxElem.archived = false;
    if( self.hud_amount >= 22 ) 
        boxElem.archived = true;
    
    boxElem.width          = width;
    boxElem.height         = height;
    boxElem.align          = align;
    boxElem.relative       = relative;
    boxElem.xOffset        = 0;
    boxElem.yOffset        = 0;
    boxElem.children       = [];
    boxElem.sort           = sort;
    boxElem.alpha          = alpha;
    boxElem.shader         = shader;
    boxElem setParent(level.uiParent);
    boxElem setShader(shader, width, height);
    boxElem.hidden = false;
    boxElem setPoint(align, relative, x, y);
    
    if(!IsDefined( server ))
        self.hud_amount++;
    return boxElem;
}

setPoint(point,relativePoint,xOffset,yOffset,moveTime)
{
    if(!isDefined(moveTime))moveTime = 0;
    element = self getParent();
    if(moveTime)self moveOverTime(moveTime);
    if(!isDefined(xOffset))xOffset = 0;
    self.xOffset = xOffset;
    if(!isDefined(yOffset))yOffset = 0;
    self.yOffset = yOffset;
    self.point = point;
    self.alignX = "center";
    self.alignY = "middle";
    if(isSubStr(point,"TOP"))self.alignY = "top";
    if(isSubStr(point,"BOTTOM"))self.alignY = "bottom";
    if(isSubStr(point,"LEFT"))self.alignX = "left";
    if(isSubStr(point,"RIGHT"))self.alignX = "right";
    if(!isDefined(relativePoint))relativePoint = point;
    self.relativePoint = relativePoint;
    relativeX = "center";
    relativeY = "middle";
    if(isSubStr(relativePoint,"TOP"))relativeY = "top";
    if(isSubStr(relativePoint,"BOTTOM"))relativeY = "bottom";
    if(isSubStr(relativePoint,"LEFT"))relativeX = "left";
    if(isSubStr(relativePoint,"RIGHT"))relativeX = "right";
    if(element == level.uiParent)
    {
        self.horzAlign = relativeX;
        self.vertAlign = relativeY;
    }
    else
    {
        self.horzAlign = element.horzAlign;
        self.vertAlign = element.vertAlign;
    }
    if(relativeX == element.alignX)
    {
        offsetX = 0;
        xFactor = 0;
    }
    else if(relativeX == "center" || element.alignX == "center")
    {
        offsetX = int(element.width / 2);
        if(relativeX == "left" || element.alignX == "right")xFactor = -1;
        else xFactor = 1;
    }
    else
    {
        offsetX = element.width;
        if(relativeX == "left")xFactor = -1;
        else xFactor = 1;
    }
    self.x = element.x +(offsetX * xFactor);
    if(relativeY == element.alignY)
    {
        offsetY = 0;
        yFactor = 0;
    }
    else if(relativeY == "middle" || element.alignY == "middle")
    {
        offsetY = int(element.height / 2);
        if(relativeY == "top" || element.alignY == "bottom")yFactor = -1;
        else yFactor = 1;
    }
    else
    {
        offsetY = element.height;
        if(relativeY == "top")yFactor = -1;
        else yFactor = 1;
    }
    self.y = element.y +(offsetY * yFactor);
    self.x += self.xOffset;
    self.y += self.yOffset;
    switch(self.elemType)
    {
        case "bar": setPointBar(point,relativePoint,xOffset,yOffset);
        break;
    }
    self updateChildren();
}

spawnObjPointer( origin, icon, width, height, alpha, color, server )
{
    if(!isDefined( server )) 
        marker = newClientHudElem( self );
    else 
        marker = newHudElem();
        
    marker.x     = origin[0];
    marker.y     = origin[1];
    marker.z     = origin[2];
    marker.alpha = alpha;
    marker.color = color;
    
    marker setshader( icon, width, height );
    marker setwaypoint( true, true );
    return marker;
}

setSafeText(text)
{
    self notify("stop_TextMonitor");
    self addToStringArray(text + "");
    self thread watchForOverFlow(text + "");
}

addToStringArray(text)
{
    if(!isInArray(level.strings,text))
    {
        level.strings[level.strings.size] = text;
        level notify("CHECK_OVERFLOW");
    }
}

watchForOverFlow(text)
{
    self endon("stop_TextMonitor");

    while(isDefined(self))
    {
        if(isDefined(text.size))
            self setText(text);
        level waittill("FIX_OVERFLOW");
    }
}

getName()
{
    name = self.name;
    if(name[0] != "[")
        return name;
    for(a = name.size - 1; a >= 0; a--)
        if(name[a] == "]")
            break;
    return(getSubStr(name, a + 1));
}

destroyAll(array)
{
    if(!isDefined(array))
        return;
    keys = getArrayKeys(array);
    for(a=0;a<keys.size;a++)
    {
        if(isDefined(array[ keys[ a ] ][ 0 ]))
        {
            for(e=0;e<array[ keys[ a ] ].size;e++)
            {
                array[ keys[ a ] ][ e ] destroy();
                array[ keys[ a ] ][ e ] = undefined;
            }
        }
        else
        {
            array[ keys[ a ] ] destroy();
            array[ keys[ a ] ] = undefined;
        }
    }
}

hudFade(alpha, time)
{
    self fadeOverTime(time);
    self.alpha = alpha;
    wait time;
}

hudFadeDestroy(alpha, time)
{
    self fadeOverTime(time);
    self.alpha = alpha;
    wait time;
    self destroy();
}

hudMoveX(x, time)
{
    self moveOverTime(time);
    self.x = x;
    wait time;
}

hudMoveY(y, time)
{
    self moveOverTime(time);
    self.y = y;
    wait time;
}

toUpper( string )
{
    alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    final    = "";
    
    for(e=0;e<string.size;e++)
    { 
        char = toLower( string[e] );
        if(isSubStr(toLower( alphabet ), char) ) 
        {
            for(a=0;a<alphabet.size;a++)
                if( char == toLower( alphabet[a] ) )
                    final += alphabet[a];
        }
        else 
            final += string[e];
    }
    return final;            
}

isInArray( array, text )
{
    for(e=0;e<array.size;e++)
        if( array[e] == text )
            return true;
    return false;        
}

customNoticon( text0, text1 )
{
    while(isDefined(self.menu["Noticon"]["Icon"][0]))
        wait .05;
    
    self.menu["Noticon"] = []; 
    self.menu["Noticon"]["Icon"] = [];
    self.menu["Noticon"]["Icon"][0] = self createRectangle("CENTER","TOPRIGHT",-150,0,50,50,(1,1,1),"white",7,0);
    self.menu["Noticon"]["Icon"][1] = self createRectangle("CENTER","TOPRIGHT",-150,0,46,46,(0,0,0),"white",8,0);
    self.menu["Noticon"]["Icon"][2] = self createRectangle("CENTER","TOPRIGHT",-150,-10,25,6,(1,1,1),"white",9,0);
    self.menu["Noticon"]["Icon"][3] = self createRectangle("CENTER","TOPRIGHT",-155,self.menu["Noticon"]["Icon"][2].y+10,15,6,(1,1,1),"white",9,0);
    self.menu["Noticon"]["Icon"][4] = self createRectangle("CENTER","TOPRIGHT",-150,self.menu["Noticon"]["Icon"][3].y+10,25,6,(1,1,1),"white",9,0);
    foreach(icon in self.menu["Noticon"]["Icon"])
        icon thread hudFade(1, .25);
    
    self.menu["Noticon"]["BG"] = self createRectangle("LEFT", "TOPRIGHT", -130, 0, 0, 50, (0,0,0), "white", 1, .6);
    self.menu["Noticon"]["BG"] scaleOverTime(.2, 170, 50);
    wait .2;
    
    self.menu["Noticon"]["Text"] = self createText("small", 1.3, "LEFT", "TOPRIGHT", -120, -8, 5, 1, text0 + "\n" + text1, (1,1,1));
    wait 4;
    
    self.menu["Noticon"]["Text"] thread hudFade(0, .1);
    self.menu["Noticon"]["BG"] scaleOverTime(.2, 0, 50);
    wait .2;
    
    self.eMenu["Noticon"]["BG"] destroy();
    for(e=2;e<5;e++)
        self.menu["Noticon"]["Icon"][e] thread hudFade(0, .15);
    self.menu["Noticon"]["Icon"][0] scaleOverTime(.2, 0, 0);
    self.menu["Noticon"]["Icon"][1] scaleOverTime(.2, 0, 0);
    wait .25;
    
    self destroyAll(self.menu["Noticon"]);
}

setColour( var, menu, curs )
{
    if( !isDefined( self.optColour ) )
        self.optColour = [];
        
    if(!IsDefined( menu ))   menu = self getCurrentMenu();
    if(!IsDefined( curs ))   curs = self getCursor();    
    
    self.optColour[ menu + curs ] = undefined;
    if( isDefined( var ) && var != false )    
        self.optColour[ menu + curs ] = true;
    self setMenuText();
}

arrySetColour( var, menu, curs )
{
    foreach( player in level.players )
        if( player hasMenu() )
            player thread setColour( var, menu, curs );
}

getColour( menu, curs )
{
    if( isDefined( self.optColour[ menu + curs ] ) ) 
        return "^2";
    return "";    
}

isConsoleFontSize( size, minus )
{
    if(level.console)
        return (size - minus);
    return size;    
}

actionSlotButtonPressed( button ) //up, down, left, right
{
    self endon("end_menu");
    self endon("disconnect");
    level endon("game_ended");
    
    if(!isDefined( self.actionSlotsPressed ))
    {
        self.actionSlotsPressed = [];   
        self notifyOnPlayerCommand( "jump", "+gostand" );
        self notifyOnPlayerCommand( "dpad_up", "+actionslot 1" );
        self notifyOnPlayerCommand( "dpad_down", "+actionslot 2" );
        self notifyOnPlayerCommand( "dpad_left", "+actionslot 3" );
        self notifyOnPlayerCommand( "dpad_right", "+actionslot 4" );
        self notifyonplayercommand( "stance", "+stance" );
    }
    
    self.actionSlotsPressed[ button ] = false;
    for(;;)
    {
        self waittill(button);
        self.actionSlotsPressed[ button ] = true;    
        wait .1;
        self.actionSlotsPressed[ button ] = false;   
    }
}

returnList( min, max, inc )
{   
    list = "";
    for(e=min;e<max;e+=inc)
    {
        if( e == max )
            list += e;
        else
            list += e + ";";
    }
    return list;
}

createRainbowColor()
{
    rainbow = spawnStruct();
    rainbow.r = 255;
    rainbow.g = 0;
    rainbow.b = 0;
    rainbow.stage = 0;
    time = 5;
    level.rainbowColour = (0, 0, 0);
    for(;;)
    {
        if(rainbow.stage == 0)
        {
            rainbow.b += time;
            if(rainbow.b == 255)
                rainbow.stage = 1;
        }
        else if(rainbow.stage == 1)
        {
            rainbow.r -= time;
            if(rainbow.r == 0)
                rainbow.stage = 2;
        }
        else if(rainbow.stage == 2)
        {
            rainbow.g += time;
            if(rainbow.g == 255)
                rainbow.stage = 3;
        }
        else if(rainbow.stage == 3)
        {
            rainbow.b -= time;
            if(rainbow.b == 0)
                rainbow.stage = 4;
        }
        else if(rainbow.stage == 4)
        {
            rainbow.r += time;
            if(rainbow.r == 255)
                rainbow.stage = 5;
        }
        else if(rainbow.stage == 5)
        {
            rainbow.g -= time;
            if(rainbow.g == 0)
                rainbow.stage = 0;
        }
        level.rainbowColour = (rainbow.r / 255, rainbow.g / 255, rainbow.b / 255);
        wait .05;
    }
}

hudMoveXY(time,x,y)
{
    self moveOverTime(time);
    self.y = y;
    self.x = x;
}