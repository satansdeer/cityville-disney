/**
 * User: dima
 * Date: 16/02/12
 * Time: 12:47 PM
 */
package game.editor {
import game.panel.PanelBase;
import game.panel.VerticalScrollablePanel;

public class EditorPanel extends VerticalScrollablePanel{
	private static const PANEL_WIDTH:Number = 100;
	private static const PANEL_HEIGHT:Number = 400;

	public function EditorPanel() {
		super(PANEL_WIDTH, PANEL_HEIGHT);
		drawInterface();
	}

	/* API */

	public function moveToRight(y:Number = 0):void {
		this.x = Main.APP_WIDTH - this.width;
		this.y = y;
	}

	/* Internal functions */

	private function drawInterface():void {
		this.graphics.lineStyle(1, 0xaacc00);
		this.graphics.drawRect(0, 0, PANEL_WIDTH, PANEL_HEIGHT);
	}
}
}
