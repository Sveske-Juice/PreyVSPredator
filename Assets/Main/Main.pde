SceneManager g_SceneManager = new SceneManager();
InputManager g_InputManager = new InputManager();

void setup()
{
    size(640, 480);
    g_SceneManager.AddScene(new GameScene());
    g_SceneManager.LoadScene("Game Scene");
}

void draw()
{
    background(200);
    g_SceneManager.UpdateScene();

}

void keyPressed()
{
    InputManager.GetInstance().RegisterKey(key);
}

void keyReleased()
{
    InputManager.GetInstance().UnregisterKey(key);    
}