import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class ControlsPlugin extends SwiperPlugin {
  @override
  Widget build(
    BuildContext context,
    SwiperPluginConfig config,
  ) =>
      Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: <Widget>[
            if (config.activeIndex != 0)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () async => config.controller.previous(),
                ),
              ),
            if (config.activeIndex != config.itemCount - 1)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () async => config.controller.next(),
                ),
              )
          ],
        ),
      );
}
