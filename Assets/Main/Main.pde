SceneManager g_SceneManager = new SceneManager();
InputManager g_InputManager = new InputManager();


void setup()
{
    //size(640, 480);
    size(1920, 1080);
    frameRate(60);
    //size(800, 800);

    // Render settings
    noSmooth(); // Better performance without smooth
    g_SceneManager.AddScene(new MenuScene());
    g_SceneManager.LoadScene("Menu Scene");
}

void draw()
{
    background(color(40, 180, 60));

    Time.Tick(millis());

    g_SceneManager.UpdateActiveScene();

    g_InputManager.GetInstance().Update();
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

void mousePressed()
{
    if (mouseButton == LEFT)
        g_InputManager.GetInstance().SetLeftMousePressed(true);
    else if (mouseButton == RIGHT)
        g_InputManager.GetInstance().SetRightMousePressed(true);
}

void mouseReleased()
{
    if (mouseButton == LEFT)
        g_InputManager.GetInstance().SetLeftMousePressed(false);
    else if (mouseButton == RIGHT)
        g_InputManager.GetInstance().SetRightMousePressed(false);
}

void mouseWheel(MouseEvent event) {
    g_InputManager.GetInstance().SetWheelAcceleration(event.getCount());
}

void mouseDragged()
{
    g_InputManager.GetInstance().SetMouseBeingDragged(true);
}