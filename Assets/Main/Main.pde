SceneManager g_SceneManager = new SceneManager();
InputManager g_InputManager = new InputManager();


void setup()
{
    size(1920, 1080);

    g_SceneManager.AddScene(new GameScene());
    g_SceneManager.LoadScene("Game Scene");
}

void draw()
{
    background(200);
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
    InputManager.GetInstance().RegisterKey(key);
}

void keyReleased()
{
    InputManager.GetInstance().UnregisterKey(key);    
}