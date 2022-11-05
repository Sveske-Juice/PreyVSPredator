SceneManager g_SceneManager = new SceneManager();

void setup()
{
    size(640, 480);
    g_SceneManager.AddScene(new GameScene("Game Scene"));
    g_SceneManager.LoadScene("Game Scene");
}

void draw()
{
    g_SceneManager.UpdateScene();
}
