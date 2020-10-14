package com.damcio.memory.game

import android.app.Activity
import android.content.Context
import android.util.Log
import android.view.View
import android.view.ViewGroup
import java.util.*
import kotlin.concurrent.timerTask

class GameState(
    private val cards: Int,
    private val context: Activity,
    container: ViewGroup
) : Observer {
    private var startDate: Date = Date();
    private var timer: Timer = Timer();
    private var onTick = timerTask { }
    private var gameCards = mutableListOf<GameCard>()
    private var clicked = Pair<GameCard?, GameCard?>(null, null)

    private var counterHits = 0
    private var counterAll = 0
    private var onScore: (hits: Int, all: Int) -> Unit = { _, _ -> }
    private var scoreTimer: Timer = Timer();
    private var onWin: (hits: Int, all: Int, seconds: Long) -> Unit = { _, _, _ -> }

    init {
        gameCards.clear()
        for (i in 1..(cards / 2)) {
            gameCards.add(GameCard(context, i))
        }
        for (card in gameCards.toList()) {
            val pair = GameCard(context, card.number)
            pair.pair = card
            card.pair = pair
            gameCards.add(pair)
        }
        gameCards.shuffle()
        for (card in gameCards) {
            card.addToGroup(container)
            card.addObserver(this)
        }
    }

    fun start() {
        startDate = Date()
        timer.scheduleAtFixedRate(onTick, 0, 1000)
    }

    fun stop() {
        timer.cancel()
    }

    fun setOnTick(cb: (seconds: Long) -> Unit) {
        onTick = timerTask { cb((Date().time - startDate.time) / 1000) }
    }

    fun setOnScore(cb: (hits: Int, all: Int) -> Unit) {
        onScore = cb
    }

    fun setOnWin(cb: (hits: Int, all: Int, seconds: Long) -> Unit) {
        onWin = cb
    }

    override fun update(o: Observable?, arg: Any?) {
        val clickedCard = o as GameCard
        if (clicked.first != null) {
            if (clicked.second == null) {
                clickedCard.show()
                clicked = Pair<GameCard?, GameCard?>(clicked.first, clickedCard)
                scoreTimer.schedule(timerTask {
                    counterAll++;
                    if (clickedCard.pair == clicked.first) {
                        counterHits++;
                    }
                    context.runOnUiThread {
                        onScore(counterHits, counterAll)
                        if (clickedCard.pair == clicked.first) {
                            clickedCard.remove()
                            clickedCard.pair?.remove()
                            if (counterHits == cards / 2) {
                                onWin(
                                    counterHits,
                                    counterAll,
                                    (Date().time - startDate.time) / 1000
                                )
                            }
                        } else {
                            clickedCard.hide()
                            clicked.first?.hide()
                        }
                        clicked = Pair<GameCard?, GameCard?>(null, null)
                    }
                }, 1000);
            }
        } else {
            clicked = Pair<GameCard?, GameCard?>(clickedCard, null)
            clickedCard.show()
        }
    }
}