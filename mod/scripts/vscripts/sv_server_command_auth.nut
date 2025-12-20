global function ServerCommandAuth_Init
global function IsServerCommandAuthed

array< string > ServerCommandAuthedPlayers // 授权玩家UID
string Command                             // 随机生成的授权命令名

void function ServerCommandAuth_Init()
{
    int randomCount = RandomInt(20)
    Command  = "Fire_ServerCommandAuth_"
    for(int i = 0; i < randomCount; i++)
    {
        Command  += RandomInt(1000).tostring()
    }
    print( "ServerCommandAuth: " + Command )

    AddConsoleCommandCallback( Command , ConsoleCommand_ServerCommandAuth)
    AddCallback_OnClientConnected( OnClientConnected )
    AddCallback_OnClientDisconnected( OnClientDisconnected )
}

bool function ConsoleCommand_ServerCommandAuth( entity player, array<string> args )
{
    string playerUID = player.GetUID()
    if( !ServerCommandAuthedPlayers.contains(playerUID) )
    {
        ServerCommandAuthedPlayers.append(playerUID)
    }
    return true
}

void function OnClientConnected( entity player )
{
    string playerUID = player.GetUID()
    if( ServerCommandAuthedPlayers.contains(playerUID) )
        return
    ClientCommand( player, Command )
}

void function OnClientDisconnected( entity player )
{
    string playerUID = player.GetUID()
    if( ServerCommandAuthedPlayers.contains( playerUID ) )
        ServerCommandAuthedPlayers.removebyvalue( playerUID )
}

bool function IsServerCommandAuthed( entity player )
{
    string playerUID = player.GetUID()
    return ServerCommandAuthedPlayers.contains( playerUID )
}