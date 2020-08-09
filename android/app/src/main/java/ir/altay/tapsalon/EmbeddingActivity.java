package ir.altay.tapsalon;

import io.flutter.embedding.android.FlutterActivity;
        import io.flutter.embedding.engine.FlutterEngine;
        import com.najva.najvaflutter.NajvaflutterPlugin;
        import dev.flutter.plugins.e2e.E2EPlugin;


public class EmbeddingActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        flutterEngine.getPlugins().add(new NajvaflutterPlugin());
        flutterEngine.getPlugins().add(new E2EPlugin());
    }
}
