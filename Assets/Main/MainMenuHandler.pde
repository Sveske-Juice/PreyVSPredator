public class MainMenuHandlerObject extends GameObject
{
    public MainMenuHandlerObject()
    {
        super("Main Menu Handler");
    }

    @Override
    public void CreateComponents()
    {
        AddComponent(new MainMenuHandler());
    }
}


public class MainMenuHandler extends Component
{
    /* Members. */
    private Scene m_Scene;
    private PlayGame m_PlayGameHandler = new PlayGame();

    /* Getters/Setters. */

    @Override
    public void Start()
    {
        m_Scene = m_GameObject.GetBelongingToScene();
        CrateMenu();
    }

    private void CrateMenu()
    {
        /*
         * Create Main Menu.
        */

        GameObject greeter = m_Scene.AddGameObject(new UIElement());
        Text greeterTxt = (Text) greeter.AddComponent(new Text());
        greeterTxt.transform().SetPosition(new ZVector(width/2f, 100f));
        greeterTxt.SetVerticalAlign(CENTER);
        greeterTxt.SetHorizontalAlign(CENTER);
        greeterTxt.SetSize(48);
        greeterTxt.SetText("Welcome");

        // Play button
        GameObject playBtnObj = m_Scene.AddGameObject(new Button("Play Button"));
        ButtonBehaviour playBtn = playBtnObj.GetComponent(ButtonBehaviour.class);
        playBtn.SetSize(new ZVector(500f, 250f));
        playBtnObj.GetTransform().SetPosition(ZVector.sub(new ZVector(width / 2f, height / 2f), ZVector.mult(playBtn.GetSize(), 0.5f))); // Center button (subtract half extents)
        playBtn.AddButtonListener(m_PlayGameHandler);
    }
}

/*
 * Button event handler. Will handle playing the game
 * when pressing the play game button.
*/
public class PlayGame implements IButtonEventListener
{
    @Override
    public void OnClick()
    {
        g_SceneManager.AddScene(new GameScene(new SmallGameSettings()));
        g_SceneManager.LoadScene("Game Scene");
    }
}