package com.proj.webprojrct.common.config.configJsp;

import java.net.URI;
import java.net.URL;

import org.apache.catalina.Context;
import org.apache.catalina.Lifecycle;
import org.apache.catalina.LifecycleEvent;
import org.apache.catalina.LifecycleListener;
import org.apache.catalina.WebResourceRoot;
import org.springframework.util.ResourceUtils;

public class JSPStaticResourceConfigurer implements LifecycleListener {

    private final Context context;

    public JSPStaticResourceConfigurer(Context context) {

        this.context = context;

    }

    private final String subPath = "/META-INF/resources";

    @Override

    public void lifecycleEvent(LifecycleEvent event) {

        if (!event.getType().equals(Lifecycle.CONFIGURE_START_EVENT)) {

            return;

        }

        final URL finalLocation = getUrl();

        this.context.getResources().createWebResourceSet(
                WebResourceRoot.ResourceSetType.RESOURCE_JAR,
                "/",
                finalLocation,
                subPath
        );

    }

    private URL getUrl() {

        final URL location = this.getClass().getProtectionDomain().getCodeSource().getLocation();

        if (ResourceUtils.isFileURL(location)) {

            return location;

        } else if (ResourceUtils.isJarURL(location)) {

            try {

                // when run as fat jar
                // transform
                // nested:/home/myfiles/Projects/myproj/myjar.jar/!BOOT-INF/classes/!/
                // to
                // jar:file:/home/myfiles/Projects/myproj/myjar.jar!/
                String locationStr = location.getPath()
                        .replaceFirst("^nested:", "")
                        .replaceFirst("/!BOOT-INF/classes/!/$", "!/");

                return new URI("jar:file", locationStr, null).toURL();

            } catch (Exception e) {

                throw new IllegalStateException("Unable to add new JSP source URI to tomcat resources", e);

            }

        } else {

            throw new IllegalStateException("Can not add tomcat resources, unhandleable url: " + location);

        }

    }

}
