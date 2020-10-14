package com.damcio.memory.game

import android.content.Context
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.GridLayout
import android.widget.ImageView
import android.widget.Toast
import androidx.preference.PreferenceManager
import com.damcio.memory.R
import com.damcio.memory.databinding.ActivityGameBinding
import kotlinx.android.synthetic.main.activity_game.view.*

class GameActivity : AppCompatActivity() {

    private lateinit var game: GameState
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val bindings = ActivityGameBinding.inflate(layoutInflater)
        setContentView(bindings.root)

        val prefs = PreferenceManager.getDefaultSharedPreferences(this)
        val cards: Int = prefs.getString("cards", "12")!!.toInt()
        game = GameState(cards, this, bindings.root.grid)
        game.setOnTick { seconds ->
            runOnUiThread {
                bindings.root.time.text = "Time: ${secondsToTimeStr(seconds)}"
            }
        }
        game.setOnScore { hits, all ->
            bindings.root.points.text = "Points: ${hits}/${all}"
        }
        game.setOnWin { hits, all, seconds ->
            val text = "Nice! You scored ${hits}/${all} in ${secondsToTimeStr(seconds)}"
            Toast.makeText(this, text, Toast.LENGTH_LONG).show()
            finish()
        }

        game.start()
    }

    private fun secondsToTimeStr(seconds: Long): String {
        val h = (seconds / 3600).toString().padStart(2, '0');
        val m = ((seconds % 3600) / 60).toString().padStart(2, '0')
        val s = (seconds % 60).toString().padStart(2, '0')
        return "${h}:${m}:${s}"
    }

    override fun onStop() {
        super.onStop()
        game.stop()
    }
}