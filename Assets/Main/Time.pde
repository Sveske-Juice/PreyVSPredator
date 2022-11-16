// Global time manager
public static class Time {

  /* Members. */
  private static float s_LastFrameTime = 0;
  private static float s_DeltaTime = 0;

  /* Getters/Setters. */
  public static float dt() { return s_DeltaTime; }
  
  public static void Tick(float millis)
  {
    s_DeltaTime = (millis - s_LastFrameTime) / 1000;
    s_LastFrameTime = millis;
  }
}
