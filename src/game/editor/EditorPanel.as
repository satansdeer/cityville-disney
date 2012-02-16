/**
 * User: dima
 * Date: 16/02/12
 * Time: 12:47 PM
 */
package game.editor {
import game.panel.PanelBase;
import game.panel.VerticalScrollablePanel;

public class EditorPanel extends VerticalScrollablePanel{
	private static const PANEL_WIDTH:Number = 300;
	private static const PANEL_HEIGHT:Number = 800;

	public function EditorPanel() {
		super(PANEL_WIDTH, PANEL_HEIGHT);
	}
}
}
