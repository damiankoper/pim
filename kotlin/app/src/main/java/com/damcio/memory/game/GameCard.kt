package com.damcio.memory.game

import android.content.Context
import android.media.Image
import android.text.Layout
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.GridLayout
import android.widget.ImageView
import androidx.appcompat.widget.AppCompatImageView
import com.damcio.memory.R
import java.util.*

class GameCard(
    private val context: Context,
    val number: Int
) : Observable() {

    class GridElement(context:Context) : AppCompatImageView(context){
        override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
            super.onMeasure(widthMeasureSpec, widthMeasureSpec)
        }
    }

    private val img = GridElement(context)
    var pair: GameCard? = null
    val resMap = mapOf<Int, Int>(
        Pair(1, R.drawable.i001_rainy),
        Pair(2, R.drawable.i002_hedgehog),
        Pair(3, R.drawable.i003_pumpkin),
        Pair(4, R.drawable.i004_mushrooms),
        Pair(5, R.drawable.i005_acorn),
        Pair(6, R.drawable.i006_berry),
        Pair(7, R.drawable.i007_turkey),
        Pair(8, R.drawable.i008_ladybug),
        Pair(9, R.drawable.i009_raccoon),
        Pair(10, R.drawable.i010_lemon)
    )
    private val p = GridLayout.LayoutParams(
        GridLayout.spec(
            GridLayout.UNDEFINED,
            1f
        ), GridLayout.spec(
            GridLayout.UNDEFINED, 1f
        )
    )

    init {
        img.setOnClickListener {
            setChanged()
            notifyObservers()
        }
    }

    fun addToGroup(viewGroup: ViewGroup) {
        img.setImageResource(R.drawable.ic_baseline_image_24)
        p.width=24
        p.height=24
        viewGroup.addView(img, p)
    }

    fun show(){
        img.setImageResource(resMap[number] ?: R.drawable.i010_lemon)
    }

    fun hide(){
        img.setImageResource(R.drawable.ic_baseline_image_24)
    }

    fun remove(){
        img.visibility = View.INVISIBLE
    }
}