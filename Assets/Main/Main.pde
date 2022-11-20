SceneManager g_SceneManager = new SceneManager();
InputManager g_InputManager = new InputManager();


void setup()
{
    //size(640, 480);
    //size(1920, 1080);
    size(800, 800);

    g_SceneManager.AddScene(new GameScene());
    g_SceneManager.LoadScene("Game Scene");
}

void draw()
{
    background(200);

    Time.Tick(millis());
    
    g_SceneManager.UpdateScene();
}

void exit()
{
    // Perform cleanup before exit
    println("Unloading active scene and leaving...");
    g_SceneManager.UnloadActiveScene();

    super.exit();
}

/* Input Events. */

void keyPressed()
{
    // Check its a special character
    if (key != CODED)
    {
        InputManager.GetInstance().RegisterKey(key);
        return;
    }
    InputManager.GetInstance().RegisterKey((char) keyCode);
}

void keyReleased()
{
    // Check its a special character
    if (key != CODED)
    {
        InputManager.GetInstance().UnregisterKey(key);
        return;
    }
    InputManager.GetInstance().UnregisterKey((char) keyCode);  
}